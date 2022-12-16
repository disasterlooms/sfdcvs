global class batch_pp_AccountCounts implements 
Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {  
        String acctType = 'VAR';
        String qry = 'SELECT Id,pp_Count_of_Contacts__c, '+
            'pp_Count_of_Enrollees_Active__c,pp_Count_of_Partner_Enrollees__c '+
            ' from account where Account_type__c = : acctType and id in (Select accountid from contact)';
        system.debug(qry);
        return Database.getQueryLocator(
            qry
        );        
    }
    
    global void execute(Database.BatchableContext bc, List<Account> records){
        
        Map<id,List<Contact>> ConAccMap = new Map<id,List<Contact>>();
         List<contact> contactsList = 
             [Select id ,Partner_Portal_Enrollment_Status__c,AccountId FROM Contact where AccountId In :records];
        
        for(Contact c : contactsList)
        {
             if(ConAccMap.containsKey(c.AccountId))
               {   
                ConAccMap.get(c.AccountId).add(c);
                   
               }
            else 
               {   
                ConAccMap.put(c.AccountId,new list<contact>{c}); 
               }
        }
        
        
        
        for(Account a : records){            
            Double cons = 0;
            Double enrolled = 0;
            Double active = 0;
            
            List<contact> contList = ConAccMap.get(a.Id);
            
            if(contList != null && contList.size()> 0 ){
                for(Contact c : contList){                
                    cons ++;
                    if(c.Partner_Portal_Enrollment_Status__c != 'Legacy - Inactive' &&
                       c.Partner_Portal_Enrollment_Status__c != 'Not Enrolled'){
                           enrolled++;
                       }
                    if(c.Partner_Portal_Enrollment_Status__c == 'Active - Enrolled'){
                        active++;
                    }
                }
            }
            a.pp_Count_of_Contacts__c = cons;
            a.pp_Count_of_Partner_Enrollees__c = enrolled;
            a.pp_Count_of_Enrollees_Active__c = active;
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