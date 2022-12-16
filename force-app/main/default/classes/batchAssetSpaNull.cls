global class batchAssetSpaNull implements 
Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        //This will batch class will run on Monday Night and add assets
        //and then on tuesday morning, there will be an update on the account level
        //as a summary. 
        
        
        return Database.getQueryLocator(
            'select id ,spaid__c from asset where spaid__c = null and purchasedate > 2020-04-01 order by account.name'
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Asset> records){        
        
        for(Asset a : records){
            a.SpaId__c = 'NoSpaGiven';
        }
        
        database.update (records,false);
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