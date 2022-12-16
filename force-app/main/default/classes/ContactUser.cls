public with sharing class ContactUser{
    
    public static void FindUser(List<Contact> records)
{
        
        

        Set<String> families = new Set<String>();
        for (Contact record : records) families.add(record.UserID__c);


       Map<String, Contact> managers = new Map<String, Contact>();
        for (Contact manager : [
            SELECT Name,Id,UserID__c,AccountId FROM Contact
            WHERE UserID__c IN :families AND UserID__c != Null
        ]) managers.put(manager.UserID__c , manager);



       List<User> users = [Select Id,Contact_ID__c from User where Id IN :families AND Country != null];

        if(users.size() >0){
       for (User  user : users){
                user.Contact_ID__c = managers.get(user.Id).Id;
                user.AccountId__c = managers.get(user.Id).AccountId;

                 update user;

            }




            
    }
}
}