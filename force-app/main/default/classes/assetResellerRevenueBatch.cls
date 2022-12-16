global class assetResellerRevenueBatch implements 
Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {        
        
        BatchQuery__mdt q = [select id,fromDate__c , toDate__c from BatchQuery__mdt  where BatchClass__c  = 'assetAccountReveneBch' limit 1];
        Date month = q.fromDate__c;
        
        String qry = 'SELECT Id, Revenue_CY__c ,Revenue_PY__c,Revenue_CQ__c,Revenue_PQ__c '+
            ' from account where Account.assetChange__c = true and Id in (Select Reseller_Account__c  from Asset where lastmodifieddate >=: month)';
        system.debug(qry);
        return Database.getQueryLocator(
            qry
        );        
    }
    
    global void execute(Database.BatchableContext bc, List<Account> records){
        
        BatchQuery__mdt q = [select id,fromDate__c , toDate__c from BatchQuery__mdt  where BatchClass__c  = 'assetAccountReveneBch' limit 1];
        Map<Id,Account> accMap = new Map<Id,Account>(records);
        
        //10.8.2020 need to check the integration because the purchase price is LineId Revenue * quantity because of the amount of times the serial numbers are shown
       
        List< AggregateResult> assResults = new List <AggregateResult >();        
        
        for(List<AggregateResult> groupedResults  : [SELECT sum(Price) rev, Reseller_Account__c  , calendar_year(purchasedate) yr
                                                     FROM Asset where Reseller_Account__c  in : records and purchasedate >= : q.fromDate__c
                                                     group by Reseller_Account__c ,calendar_year(purchasedate)]){
            assResults.addAll(groupedResults);
        }
        
        system.debug('group res');
        system.debug(assResults);
               
        Map<Id,Account> acctToUpdate = new Map<Id,Account>();
        String accid = '';
        for(AggregateResult ar : assResults ){
            accid = String.valueOf(ar.get('Reseller_Account__c'));
			Integer ayr = Integer.valueOf(ar.get('yr'));             
            if(accmap.containsKey(accid)){
                Account acc = new Account();
                acc.Id = accid;
                acc.assetChange__c = false;
                system.debug('mapped the account Id. ');
                if(ayr == Date.Today().year()){ 
                     acc.Revenue_CY__c = Double.valueOf(ar.get('rev'));
                }else if(ayr == Date.Today().year() -1){
                     acc.revenue_PY__c = Double.valueOf(ar.get('rev'));
                }
                acctToUpdate.put(acc.Id,acc);
            }
        }
        Database.DMLOptions dml = new Database.DMLOptions(); 
        dml.DuplicateRuleHeader.allowSave = true;
        dml.OptAllOrNone = false;
        
        try{
             update acctToUpdate.values();
        }catch(Exception e){
            String recId = accid;String objType  ='Account';String apexClass ='assetAccountReveneBch';String errMessage = e.getmessage();
            apexerrorlog.logError(recId, objType, apexClass, errMessage);database.update (acctToUpdate.values(),dml);
        }   
       
        
        
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