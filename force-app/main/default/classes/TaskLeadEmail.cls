public with sharing class TaskLeadEmail{
    
    public static void findLead(List<Task> records)
    {
        // create a list of string values of families based on the triggered records
        Set<String> families = new Set<String>();
        //iterate over the triggered values, and put the whoid in the list to query again in the string list based on task type
        for (Task record : records){

        if(record.Type == 'Email' &&  record.WhoId.getSobjectType() == Schema.Lead.sObjectType ){
            families.add(record.WhoId);
            }else{

            }
        
        }
        if(!families.isEmpty()) {

        List<Lead> leadsToUpdate = new List<Lead>();
        
        List<Lead> members =  [
            SELECT Id,Email_Sent__c FROM Lead
            WHERE Id  IN :families
        ];
        if(!members.isEmpty()) {
         for(Lead l : members) { 
         l.Email_Sent__c = true;
         
        leadsToUpdate.add(l);
    }
    update leadsToUpdate;
}
}
}
   }