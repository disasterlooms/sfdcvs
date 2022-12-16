public with sharing class TaskCampaignMember {
    public static void findCampaign(List<Task> records)
    {
        List<CampaignMember> membersToUpdate = new List<CampaignMember>();
        for (Task t: records){

        
        List<CampaignMember> members =  [SELECT Id,CampaignId, Emails__c, Email_Sent__c, LeadId FROM CampaignMember 
        		WHERE LeadId = : t.WhoId AND LeadId != Null Limit 1 ];
        		if(members.size() > 0) {
        		for (CampaignMember c: members){
        				 c.Email_Sent__c = true;
         if(c.Emails__c == null){
            c.Emails__c = 1;
            }else{
                c.Emails__c = c.Emails__c + 1;
            }
            update c;
    
   }   
}
            }
}
public static void campaignact(List<Task> records)
    {
         
        List<Task> taskToUpdate = new List<Task>();      
        Set<String> leads = new Set<String>();
        for (Task record : records) 
            leads.add(record.WhoId);

     Map<String, CampaignMember> managers = new Map<String, CampaignMember>();
        for (CampaignMember manager : [
            SELECT Name,Id,LeadOrContactId,CampaignId FROM CampaignMember
            WHERE LeadOrContactId IN :leads
        ]) managers.put(manager.LeadOrContactId , manager);


        for(Task t : [Select Id,Campaign__c,WhoId,NewTask__c from Task where Id In :records]) { 
            t.Campaign__c = managers.get(t.WhoId).CampaignId;
            taskToUpdate.add(t);

         try{
            update taskToUpdate;

         }catch(Exception e){

         }
         
     }
    




       
    }
}