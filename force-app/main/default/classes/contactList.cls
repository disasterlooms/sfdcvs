public class contactList {

     @AuraEnabled
    public static List<Contact> getContacts(String accId){
        
        List<Contact> cons = [Select id,Name,Email,Title,Marketing_Post_Sales__c,
                              Account.Name,MailingState,Account.Parent.Name
                              from Contact 
                              where AccountId =: accId];
        return cons;
                                  
        
    }
     @AuraEnabled
    public static void updateContacts( List<Contact> cons){
        
        update cons;
        
    }
}