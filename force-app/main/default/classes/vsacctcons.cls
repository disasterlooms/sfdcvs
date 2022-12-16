public with sharing class vsacctcons{
    
    public static void FindUser(List<Account> records)
{
        
        

        //Set<String> families = new Set<String>();
        for (Account record : records) {
         if(record.GetVSContacts__c == false){
          return;
          }else{
             record.GetVSContacts__c = false;
             List<Contact> constoInsert = new List<Contact>();

       List<User> users = [SELECT Id,FirstName,LastName,Email,Phone,Street,City,State,PostalCode,Country,IsActive FROM User where IsActive = true AND UserType  = 'Standard' AND Country ='United States'] ;
             for (User  u : users){
                Contact con = new Contact(FirstName = u.Firstname,
                    LastName = u.LastName,
                    Email = u.Email,
                    Phone = u.Phone,
                    MailingStreet = u.Street,
                    MailingCity = u.City,
                    MailingState = u.State,
                    MailingPostalCode = u.PostalCode,
                    MailingCountry = u.Country,
                    AccountId = record.Id,
                    UserId__c = u.id
                    );
                constoInsert.add(con);

                }
                insert constoInsert;                
                }
                
                
            
    }
}
}