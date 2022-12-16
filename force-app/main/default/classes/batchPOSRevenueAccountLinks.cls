global class batchPOSRevenueAccountLinks implements 
Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        //This will batch class will run on Monday Night and add assets
        //and then on tuesday morning, there will be an update on the account level
        //as a summary. 
        
        
        return Database.getQueryLocator(
            'Select id, POS_Revenue__c ,(select id from POS_Revenue__r) from account where id in (select Account_Name__c  from POS_Revenue__c)'
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Account> records){        
        
        for(Account a : records){
            for(POS_Revenue__c r :a.POS_Revenue__r){
                a.POS_Revenue__c = r.Id;
            }
        }
        Database.SaveResult[] srList = database.update (records,false);
        List<AccountUpdateErrors__c> errors = new List<AccountUpdateErrors__c>();
        
        for (Integer i = 0; i < srList.size(); i++) {
            AccountUpdateErrors__c acError = new AccountUpdateErrors__c ();
            if(!srList[i].isSuccess()){
                acError.Account__c = records[i].Id;
                //system.debug('acct id '+records[i].Id);
                for(Database.Error err : srList[i].getErrors()) {
                    acError.ErrorMessage__c = err.getStatusCode() + ': ' + err.getMessage();
                }
                 errors.add(acError); 
            }
           
        }
        
        insert errors;
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