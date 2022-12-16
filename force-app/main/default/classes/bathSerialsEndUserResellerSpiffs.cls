global class bathSerialsEndUserResellerSpiffs implements 
Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        //This will batch class will run on Monday Night and add assets
        //and then on tuesday morning, there will be an update on the account level
        //as a summary. 
        
        String vsacctid = '0011200001Dq2NAAAZ';
        if(test.isRunningTest()){
            vsacctid = [Select id from account where name = 'ViewSonic Corporation' limit 1].Id;
        }
        return Database.getQueryLocator(
            'select id, accountid, reseller_account__r.name, Spiff_Request__r.requester_company__c ,'+
            'Spiff_Request__r.End_User__c,Spiff_Request__r.requester__r.AccountId , '+
            ' createddate from asset where accountid =: vsacctid  and Spiff_Request__r.End_User__c != null'
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Asset> records){       
        
        for(Asset a : records){
            if(a.Spiff_Request__r.End_User__c != null){
				a.AccountId = a.Spiff_Request__r.End_User__c;
            }
            a.reseller_account__c = a.Spiff_Request__r.requester_company__c;
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