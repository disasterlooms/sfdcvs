public class TaskUpdate{
    Map<Id,Task> oldTasks;
    Map<Id,Task> newTasks;
    public TaskUpdate(Map<Id,Task> oTasks,Map<Id,Task> nTasks){
        oldtasks = oTasks;
        newTasks = nTasks;        
    }
    public void reminder(){
        Set<Id> tasks = new Set<Id>();
        for(Task t : newTasks.values()){
            Task ot = oldTasks.get(t.Id);
            if(t.isClosed == false && t.IsReminderSet == false && ot.IsReminderSet == true){
                tasks.add(t.Id);
            }
        }
        TaskUpdate.updatereminders(tasks);
    }
    @future
    public static void updatereminders(Set<ID> tasks){
        TriggerContextUtility.setFirstRunFalse();  
        List<Task> tupdates = [Select id,IsReminderSet,ReminderDateTime from task where id in: tasks ];
        
        for(Task t : tupdates){
             t.IsReminderSet = true;
             t.ReminderDateTime = datetime.now()+1;
        }
        system.debug('tasks in future');
        system.debug(tupdates);
        update tupdates;
    }
    public static void findTask(List<Task> records)
    {   
        /*List<Task> TaskswithLead = 
            //[SELECT Id,WhoId FROM Task WHERE Id IN :records];
        
        for(Task t : records) { 
            t.Concerns__c = 'email';  
            //update t;
        }
		*/
    }
    
    public static void spaSent(List<Task> records)
    {
        
        /*Set<String> quotes = new Set<String>();
        for(Task t :records){
            if(t.subject == 'Approved Spa Sent'){
                quotes.add(t.WhatId);
            }
        }
        
        List<Quote> spasent = [Select Id,Status,Approval_Date__c, Resubmission_Approval_Date__c,Spa_Stage__c,Resubmission_Notes__c 
                               from Quote where Id in: quotes];
        
        if(spasent.size() >0){
            for(Quote q : spasent){
                q.Status = 'Approved';
                if(q.Spa_Stage__c == 'Submitted'){
                    q.Approval_Date__c = date.Today(); 
                }else{
                    q.Resubmission_Approval_Date__c = date.Today();
                    q.Resubmission_Notes__c = null;
                }
            }
            
            //update spasent;
        }
		*/
    }
    
    
    public static void oppowner(List<Task> records)
    {
        
        // from the trigger will get the needed fields, a list to loop through
        // records that are opportunities to keep list to only records need
        // going to map the opportunity ids that are related to the task and then 
        // update the task to show that this is an activity that was not created
        // by  the sales rep and they are working on closing a deal that they did  not
        // create and give credit for this assist and count 
        // thier opps created separately, thus giving visibility in total points 
        // and assists
        // 
        
        //List<Task> TaskswithOpp = [SELECT Id,WhatId,OwnerId,OppCreatedByOther__c
                                   //FROM Task WHERE Id IN :records
                                   //and what.type = 'Opportunity'];
        
        
        
        //Set<String> tasks = new Set<String>();
        //for (Task record : TaskswithOpp) tasks.add(record.WhatId);
        
        //Map<ID, Opportunity> opps = new Map<Id, Opportunity>();
        //for (Opportunity opp : [Select Id,OwnerId 
                                //from Opportunity 
                                //where Id in: tasks])
            //opps.put(opp.Id, opp);
        
        
        
        //for(Task t : TaskswithOpp) { 
            
            //Opportunity o  = opps.get(t.whatId);
            //system.debug('task owner '+t.OwnerId+' opp owner '+o.OwnerId);
            //if(t.OwnerId != o.OwnerId){
                
                //t.OppCreatedByOther__c = true;
            //}
            //update t;
        //}
        
    }
    public static void campaign(List<Task> records)
    {
        
        //get new tasks and add them as campaign memebers when appropriate
        //this allows better tracking on reports to count the amount of activities
        //that are done after a contact or lead is added to a campaign
        //specifically finch club, customer service leads, and 
        //trade show leads need to show if there is follow up with leads/contacts
        
        List<Task> taskToUpdate = new List<Task>();      
        Set<String> leads = new Set<String>();
        for (Task record : records) 
            leads.add(record.WhoId);
        /*
        Map<String, CampaignMember> managers = new Map<String, CampaignMember>();
        for (CampaignMember manager : [
            SELECT Name,Id,LeadOrContactId,CampaignId FROM CampaignMember
            WHERE LeadOrContactId IN :leads
        ]) managers.put(manager.LeadOrContactId , manager);
        
        
        //for(Task t : [Select Id,Campaign__c,WhoId,NewTask__c from Task where Id In :records]) { 
            //t.NewTask__c = true; 
            //taskToUpdate.add(t);
            
            //try{
                //update taskToUpdate;
                
            //}catch(Exception e){
                
            //}
            
        //} 
        */
    }
}