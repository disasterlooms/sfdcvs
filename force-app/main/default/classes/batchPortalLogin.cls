global class batchPortalLogin implements 
Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        //This will batch class will run on Monday Night and add assets
        //and then on tuesday morning, there will be an update on the account level
        //as a summary. 
         
       Datetime yest =  System.now().addDays(-1);
       String testLimit = ' ';
        if(Test.isRunningTest()){
            testLimit = ' limit 200 ';
        }
        return Database.getQueryLocator(
            'SELECT Id,LoginType,LoginTime,Platform,UserID from LoginHistory where LoginTime >: yest '+
            ' and userId in (Select id from User where contactid != null) '+(Test.isRunningTest()?'LIMIT 200':'')
        );
    }
    
    global void execute(Database.BatchableContext bc, List<LoginHistory> records){
        Map<String,LoginHistory> lh = new Map<String,LoginHistory>();
        system.debug(records);
        Set<String> uIds = new Set<String>();
        for(LoginHistory l : records){
            lh.put(l.UserId, l);
            uIds.add(l.userId);
        }        
        List<User> users = [Select id, lastlogin__c from User where id in : uIds];
        for(User u : users){
            if(lh.containsKey(u.Id)){
                LoginHistory l = lh.get(u.Id);
                u.lastlogin__c = l.LoginTime;
            }
        
        }
        
        update users;
       
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