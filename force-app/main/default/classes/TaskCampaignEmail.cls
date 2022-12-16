public with sharing class TaskCampaignEmail{
    
    public static void findCampaign(List<Task> records)
    {
        // create a list of string values of families based on the triggered records
        Set<String> families = new Set<String>();
        //iterate over the triggered values, and put the whoid in the list to query again in the string list based on task type
        for (Task record : records) {
             families.add(record.WhoId);
        }
        
        //create a new list for updated campaign members
        List<CampaignMember> membersToUpdate = new List<CampaignMember>();
        
        // query a list of records that whoid is also in the memberid. The multiple where statements is to ensure that if whoid is blank, that it does not pull up any 
        //records that do have either no contactid or no leadid as this will cause an update of a lot of records. It may become neccessary to check on the
        //families list for records, but that was not working and that is why we are using this model. 
        List<CampaignMember> members =  [
            SELECT Id,CampaignId, Emails__c,   Email_Sent__c FROM CampaignMember
            WHERE (LeadId  IN :families AND LeadId != Null) OR (ContactId IN :families AND ContactId != Null)
        ];
        //check if there is query results
        if(members.size() > 0) {
         for(CampaignMember c : members) { 
        //go through the list and update the amount of emails of the member and that there was an email. this is for rollup field on the campaign 
         c.Email_Sent__c = true;
         if(c.Emails__c == null){
            c.Emails__c = 1;
            }else{
                c.Emails__c = c.Emails__c + 1;
            }
            //add the list of records

        membersToUpdate.add(c);
    }
     //update the list of records
    update membersToUpdate;

    
   }   
}
}