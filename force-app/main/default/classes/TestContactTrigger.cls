@isTest
private class TestContactTrigger{
    //add test build..will still have some custom records created 
    //but this base of records will allow scalibility for this test without
    //having to create multiple records and update when validation rules
    //or picklists changes are made to the metadata
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void ContactTrigger() {
        // set up some test data to work with
        Test.Starttest();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            
            Campaign camp2 = new Campaign(
                Name= 'Customer Service Incoming Call',
                Status = 'In Progress',
                IsActive=true             
            ); 
            insert camp2; 
            
            Account a = [Select ID, BillingStreet,BillingCity,BillingState from Account where Name='ZZpbest' Limit 1];
            
            a.BillingStreet ='new street testing lane';
            update a;
            
            Contact c = new Contact(FirstName = 'just a test', LastName = 'Apex Test', Email = 'puser000@amamama.com', UserID__c = thisUser.id, AccountId = a.id);
            insert c;
            //contact con = [Select Id, GetUserId__c from Contact Where Id =: c.Id];
            
            
            Contact cerror = new Contact(FirstName = 'just a test', LastName = 'Apex Test', Email = 'puser000@amamama.com', UserID__c = thisUser.id, AccountId = a.id);
            database.insert (cerror,false);
            
            Contact actaddress = new Contact(FirstName = 'just a test', LastName = 'Apex Test', Email = 'puser000@amamama.com', UserID__c = thisUser.id, AccountId = a.id,Same_Address_As_Account__c=true);
            //insert actaddress;
            
            TriggerContextUtility.setFirstRunTrue();
            c.Log_Customer_Request__c ='test the camp';
            update c;
            
            TriggerContextUtility.setFirstRunTrue();
            c.Portal_Acct_Verified__c = true;
            //update c;
            
            List<Contact> cons = [Select id from contact where Log_Customer_Request__c != null limit 1];
            //run update owner which runs the log customer request class after creating map classes
            ContactUpdate.UpdateOwner(cons);
            
            Contact finchnocamp = new Contact(FirstName = 'just a test finch', LastName = 'Apex Test', Email = 'puser000finch@amamama.com', UserID__c = thisUser.id, AccountId = a.id);
            insert finchnocamp;
            TriggerContextUtility.setFirstRunTrue();
            
            Campaign fc = new Campaign(Name = 'Finch Club Members',IsActive = true,Status = 'In Progress');
            insert fc;
            
            //insert a finch club member after we have a finch club campaign
            Contact finchcamp = new Contact(FirstName = 'just a test fc', LastName = 'Apex Test fc', Email = 'puser000fc@amamama.com', UserID__c = thisUser.id, AccountId = a.id);
            insert finchcamp;
            //update the member and see if we get the error because member already exists
            TriggerContextUtility.setFirstRunTrue();
            update finchcamp;
            
            TriggerContextUtility.setFirstRunTrue();
            delete finchcamp;
            
            TriggerContextUtility.setFirstRunTrue();
            undelete finchcamp;
            
            
            
        }
        
        Test.stopTest();
    }
     static testmethod void ContactAcctMap() {
         Test.Starttest();
         Set<Id> cons = new Set<Id>();
         Set<Id> accts = new Set<Id>();
         
         Account a = [Select ID, BillingStreet,BillingCity,BillingState from Account where Name='ZZpbest' Limit 1];
         Contact c = new Contact(FirstName = 'just a test fc', LastName = 'Apex Test fc', Email = 'puser000fc@amamama.com', AccountId = a.id);
         insert c;
         
         cons.add(c.Id);
         AccountContactOwnerUpdate.UpdateOwners(cons, accts);
         
         accts.add(a.Id);
         
         //AccountContactOwnerUpdate.UpdateOwners(cons, accts);
         //AccountContactOwnerUpdate.AccountAddress(accts);
         
         Test.Stoptest();
         
     }
}