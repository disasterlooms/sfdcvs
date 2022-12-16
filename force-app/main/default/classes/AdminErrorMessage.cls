public class AdminErrorMessage
{
    public static void SendError(Exception e,String t){
    
        User u = [ select Id,Name from User where Id = :UserInfo.getUserId() ];
        if(limits.getEmailInvocations() < 9 ){     

       Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {Label.AdminEmail};
       mail.setToAddresses(toAddresses);
            mail.setReplyTo(Label.AdminEmail);
            mail.setSenderDisplayName('Apex  '+t+ ' error message');
            mail.setSubject('Error from Org : ' + UserInfo.getOrganizationName());
            mail.setPlainTextBody(e.getMessage()+' User'+u.Name);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
          }

          User_Interactions__c ui = new User_Interactions__c (Interaction_Name__c = t,
                                                  User__c = u.Id);         
            insert ui;
            
            
   }
            
}