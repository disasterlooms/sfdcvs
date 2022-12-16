public class accountVBContact {
 	public Id accId {get;set;}
    public List<Contact> getCons() {
        List<Contact> cons = new List<Contact>();
         
         cons = [Select id, name, firstname,lastname,phone,email,mailingstate,ViewBoard_User_Type__c
                 from contact where accountId =: accId and ViewBoard_User_Type__c != null];

         return cons;        
    }

}