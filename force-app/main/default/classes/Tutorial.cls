public without sharing class Tutorial {
    @auraEnabled
    public static lightningtutorial__c getUser(){
        lightningtutorial__c tut = new lightningtutorial__c();
        String t = 'the user is not set up for lightinging tour';
        try{
            tut = [Select id,SetupOwnerId,
                                  Counter__c, Date__c, Never__c, Later__c, ActivityReminders__c  FROM lightningtutorial__c 
                                  where SetupOwnerId =: userinfo.getUserId()   limit 1];            
        }catch(exception e){            
            AdminErrorMessage.SendError(e, t);
        }        
        system.debug(tut);
        return tut;
    }
    @auraEnabled
    public static void updateSettings(lightningtutorial__c settings){
        settings.Date__c = date.today();
        settings.Counter__c = settings.Counter__c+1;        
        system.debug(settings+ ' settings');
        update settings;        
    }
    @auraEnabled
    public static void updateTask(lightningtutorial__c settings){
        settings.ActivityReminders__c = date.today();
        update settings;        
    }
    @auraEnabled
    public static List<Task> activities(String whereclause){
        String userid = userinfo.getUserId();
        Date n = date.today();
        DescribeSObjectResult describeResult = Task.getSObjectType().getDescribe();
        
         List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
         String query =      ' SELECT ' +          String.join( fieldNames, ',' ) +      ', what.Name, Who.Name FROM '
            +          describeResult.getName()  + ' where isClosed = false and ActivityDate < :n and OwnerId =:userid '+whereclause+' order by ReminderDateTime desc'  ;    
        // return generic list of sobjects or typecast to expected type
        system.debug(query);
        List<SObject> records = Database.query( query );    
        System.debug('the found tasks' +records );
        
        return records;
    }
    @auraEnabled
    public static void TasktoUpdate(String recordId, Boolean status){
         DescribeSObjectResult describeResult = Task.getSObjectType().getDescribe();
        
         List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
         String query =      ' SELECT ' +          String.join( fieldNames, ',' ) +      ', what.Name, Who.Name FROM '
            +          describeResult.getName()  + ' where id =: recordid '  ;    
        // return generic list of sobjects or typecast to expected type
        system.debug(query);
        List<Task> records = Database.query( query );
        
        //will set this up to update the status field. in the future we can add fields to update. will need to update
        //this class to do this
        for(Task t : records){
            if(status == true){
                t.Status = 'Completed';                
            }            
        }
        update records;
		system.debug('task '+records+' was updated to complete');        
        
    }
      @auraEnabled
    public static void deleteTask(String recordId){
        Task t = [select id from task where id = : recordId limit 1];
        delete t;
    }

}