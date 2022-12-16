global class PosSpaBatch implements 
Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        //This will batch class will run on Monday Night and add assets
        //and then on tuesday morning, there will be an update on the account level
        //as a summary. 
        
        
        return Database.getQueryLocator(
            'select id,Distributor__c ,Product__c ,Reseller__c ,Revenue__c , SaleDate__c ,Serial_Number__c, SpaId__c , SpaIdKey__c   from PosSerialNumber__c'
        );
    }
    
    global void execute(Database.BatchableContext bc, List<PosSerialNumber__c> sers){
        //
        //Need to get records of object and then clean up the spaid to take away any spaces, text, or special characters. It should only
        //be numeric values. We will then use the spa id to map the accountid for the deal
        //then insert as assest the record
        //then delete the records in pos serial number
        //because it is a pass through for pos serial numbers, alllowing post
        //processing on informatica
        //
        

        Set<String> spas = new Set<String>();
                
        for(PosSerialNumber__c s : sers){
            String spa = s.SpaIdKey__c ;
            
            spa = spa.remove(' ');
            spa = spa.remove('/');
            spa = spa.remove('br');
            spa = spa.remove('acc');
            spa = spa.remove('-');
            spa = spa.remove('/');
            
            s.SpaId__c  = spa;
            spas.add(spa);
            
        }
                
        Set<Id> acc = new Set<Id>();        
        Map<String, Opportunity> opps = new Map<String,Opportunity>();
        
        for(Opportunity o : [Select id, AccountId, Spa_ID__c from opportunity where Spa_ID__c in : spas]){
            opps.put(o.SPA_ID__c , o);
            acc.add(o.AccountId);      
        }     
        
        List<Asset> serials = new List<Asset>();
        for(PosSerialNumber__c s : sers){
            if(opps.containsKey(s.SpaId__c)){
                Opportunity o = opps.get(s.SpaId__c);
                
                Asset a = new Asset();
                a.AccountId = o.AccountId;
                a.SerialNumber = s.Serial_Number__c;
                a.Product__c  = s.Product__c;
                a.PurchaseDate = s.SaleDate__c;
                a.Price = s.Revenue__c;
                a.Reseller__c = s.Reseller__c;
                a.Distributor__c = s.Distributor__c;
                a.name = s.Serial_Number__c;
                serials.add(a);

            }
        }        
        insert serials;
        delete sers;
        
    }    
    
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. disaster averted!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        system.debug(job);
    }    
    
}