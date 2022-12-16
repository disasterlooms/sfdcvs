public without sharing class portalProfileUpdate implements Queueable {  
    Set<Id> records = new Set<Id>();
    @testVisible
    private static Boolean doChainJob = true;
    public portalProfileUpdate(Set<Id> records) {  
        
        this.records = records;  
    }    
    public void execute(QueueableContext qc) { 
        
        List<User> us = [Select id, profileId from User where ContactId in : records];
        
        Profile p = [Select id from Profile where name = 'Partner Community Login Verified' limit 1];
        
        for(User u: us){
            u.ProfileId = p.Id;
        }
        //database.update(us,false);
        TriggerContextUtility.setFirstRunFalse();    
        update us;
        
        if(!Test.isRunningTest()){
           System.enqueueJob( new portalGroupVerified(records));  
        }
        
        
    }  
    
}