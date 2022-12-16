global class batch_pp_Account_ActiveEnrolled implements 
Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {  
        String acctType = 'VAR';
        String Status ='Active - Enrolled';
        String qry = 'SELECT Id, (Select id from Contacts where '+
            ' Partner_Portal_Enrollment_Status__c != : status) '+
            ' from account where Account_type__c = : acctType';
        system.debug(qry);
        return Database.getQueryLocator(
            qry
        );        
    }
    
    global void execute(Database.BatchableContext bc, List<Account> records){
        for(Account a : records){
        a.pp_Count_of_Enrollees_Active__c  = a.Contacts.size();  
        }
        
              
        
        Database.DMLOptions dml = new Database.DMLOptions(); 
        dml.DuplicateRuleHeader.allowSave = true;
        dml.OptAllOrNone = false;
        
       
        
        try{
            update records;
        }catch(Exception e){
            String recId = records[0].Id;String objType  ='Account';String apexClass ='batch_pp_AccountCounts';String errMessage = e.getmessage();
            apexerrorlog.logError(recId, objType, apexClass, errMessage);database.update (records,dml);
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