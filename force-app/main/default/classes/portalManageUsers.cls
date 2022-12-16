public without sharing class portalManageUsers {
    public class conList{        
        @AuraEnabled public List<conUser> ContactList{get;set;}    
    }    
    
    public class conUser{
        @AuraEnabled public String conId;
        @AuraEnabled public String conName;
        @AuraEnabled public String conEmail;
        @AuraEnabled public String conAcct;
        @AuraEnabled public String userId;
        @AuraEnabled public Boolean UserActive;
        @AuraEnabled public String title;
    }  
    
    @future
    public static void processUsers(List<ID> records)
    {   
        List<User> u = [Select id,IsPortalEnabled from User where id in : records];
        for(User c: u){
            c.isActive = false;
        }
        update u;
    }
    
    @future
    public static void processContact(List<ID> records)
    {   
        List<Contact> cons = [Select id, recordTypeId,Status__c from Contact where id in : records];        
        Id recType = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get('Inactive').getRecordTypeId();
        for(Contact c: cons){
            c.recordTypeId = recType;
        }
        update cons;

    }
    @AuraEnabled
    public static  void inactive(String conid,String userid) {      
        List<Id> con = new List<Id>();
        List<Id> use = new List<Id>();
        con.add(conid);
        use.add(userid);
        portalManageUsers.processContact(con);
        portalManageUsers.processUsers(use);
       
        
    }
    @AuraEnabled
    public static  List<conUser> getUsers() {        
        //List <ContactList> = new  List <ContactList> (); 
        //get the user id to get the account id and find 3 level of parents 
        //to get all the accounts and all contacts 
        
        User curUser = [Select Contact.Account.ParentID__c from User where Id =: UserInfo.getUserId() limit 1];
        
        //Account a = [Select ParentID__c, Id from Account where id in (Select Accountid from User where Id =: UserInfo.getUserId() or accountid ='0011H00002EmbPt' )];
        
        String acct = curUser.Contact.Account.ParentID__c;
        if(System.Test.isRunningTest()){
            acct =  [Select id, ParentID__c from Account where id in (Select Accountid from Contact) limit 1].ParentID__c;
        }
        system.debug('acc id '+ acct);
        
        List<Contact> cons = [Select id ,name, email,title from Contact where Account.ParentID__c =: acct and recordtype.name != 'Inactive'];
        system.debug('cons siz '+cons);
        Map<String,User> us = new Map<String,User>();
        
        
        for(User u : [Select id, contactId , isactive from user where contactId in : cons]){
            us.put(u.ContactId, u);
        }            
        system.debug('users siz '+us);
        List<conUser> userList = new List<conUser>();
        for(Contact c : cons){
            conUser cu = new conUser();
            cu.conId = c.Id;
            cu.conName = c.Name;
            cu.conEmail = c.email;
            cu.title = c.Title;
            
            if(us.containsKey(c.Id)){
                User u = us.get(c.Id);
                cu.UserActive = u.IsActive;
                cu.userId = u.Id;
            }
            userList.add(cu);
        }  
        
        return userList;
        
        
    }
}