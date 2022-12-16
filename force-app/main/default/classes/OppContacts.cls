public class OppContacts {
    @AuraEnabled
    public static List<OpportunityContactRole> getOppContacts(String oppid){
        system.debug('oppid is ' +oppid);
        
        return [SELECT Id, OpportunityId,Contact.Name,Contact.Account.Name
                FROM OpportunityContactRole
                WHERE OpportunityId = :oppid];  
    }
    
     @AuraEnabled
    public static List<OpportunityContactRole> sendEmail(List<OpportunityContactRole> consToMail, String oppid){        
        
        return [SELECT Id, OpportunityId,Contact.Name,Contact.Account.Name
                FROM OpportunityContactRole
                WHERE OpportunityId = :oppid];  
         
       
    }

}