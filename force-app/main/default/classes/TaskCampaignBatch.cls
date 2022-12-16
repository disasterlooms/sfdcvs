global class TaskCampaignBatch implements
     Database.Batchable<sObject> {
    
    global Integer recordsProcessed = 0;

    global TaskCampaignBatch() {
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String admin = Label.AdminID;
        String biddesk = Label.BidDeskUserId ;

        return Database.getQueryLocator('SELECT ID,Campaign__c,WhoId,CampaignCheck__c FROM Task Where WhoId != null And Campaign__c = null'
        +' And CreatedById !=: biddesk And CreatedById !=: admin And CreatedDate > Yesterday');
        
        
    }


    global void execute(Database.BatchableContext BC, List<Task> tasks) {
        system.debug('records found '+ tasks);

        List<Task> taskToUpdate = new List<Task>();      
        Set<String> leads = new Set<String>();
        for (Task task : tasks) 
            leads.add(task.WhoId);

     Map<String, CampaignMember> managers = new Map<String, CampaignMember>();
        for (CampaignMember manager : [
            SELECT Name,Id,LeadOrContactId,CampaignId FROM CampaignMember
            WHERE LeadOrContactId IN :leads
        ]) managers.put(manager.LeadOrContactId , manager);

      for(Task t : [Select Id,Campaign__c,WhoId,CampaignCheck__c from Task where Id In :tasks]) { 
             if (managers.containsKey(t.WhoId))

            t.Campaign__c = managers.get(t.WhoId).CampaignId;
            t.CampaignCheck__c = true;
            taskToUpdate.add(t);

         try{
            update taskToUpdate;

         }catch(Exception e){

         }
       } 


    
    }
    
    global void finish(Database.BatchableContext BC) {

        System.debug(recordsProcessed + ' task records processed.');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        // call some utility to send email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'jason.orbison@viewsonic.com'};
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('jason.orbison@viewsonic.com');
        mail.setSenderDisplayName('Apex Batch Results');
        mail.setSubject('Batch task campaign result: ');
        mail.setPlainTextBody('Errors: ' + job.NumberOfErrors + ' Total Job Items '+ job.TotalJobItems);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
    
}