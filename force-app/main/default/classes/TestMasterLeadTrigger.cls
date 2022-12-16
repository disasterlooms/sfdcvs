@isTest
private class TestMasterLeadTrigger{
    @testSetup 
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void MasterLeadTrigger() {
        // set up some test data to work with
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        Test.Starttest();    
        Account a = [Select id,website,domain__c from account where website != null limit 1];
        
        List<Lead> leads = new List<Lead>();
        Contact c = new Contact(LastName = 'apex test',email= 'lostestingcon@apex.com', AccountId = a.Id);
        insert c;
        
        Lead l = new Lead (LastName='Just a Test delete', StateCode='CA',CountryCode='US',Company='ApexTestDelete',email= 'lostesting@'+a.domain__c);
        leads.add(l);
        
        Lead l2 = new Lead (LastName='Just a Test delete',Company='ApexTestDelete' ,Country='United Kingdom',CountryCode = 'GB');
        leads.add(l2);
        
        Lead finchnocamp = new Lead(FirstName = 'just a test finch',Company='finch company', LastName = 'Apex Test', Email = 'puser000finch@amamama.com');
        
        leads.add(finchnocamp);
        
        Campaign fc = new Campaign(Name = 'Finch Club Members',IsActive = true,Status = 'In Progress');
        insert fc;
        
        
        //insert a finch club member after we have a finch club campaign
        Lead finchcamp = new Lead(FirstName = 'just a test fc',Company='finch company',
                                  LastName = 'Apex Test fc',CountryCode = 'US', Email = 'puser000fc@amamama.com',ownerid=thisUser.Id);
        
        leads.add(finchcamp);
        
        insert leads;
        //update the member and see if we get the error because member already exists
        TriggerContextUtility.setFirstRunTrue();
        //test out finchcamp and log call classes from trigger
        finchcamp.Log_Customer_Request__c = 'test this out my friend';
        update finchcamp;
        
        LeadStateFind.findState(leads);
        Test.stopTest();
        
        Lead us = [Select id , country, VSRegion__c from Lead where id =: l.Id limit 1];
        Lead uk = [Select id , country, VSRegion__c from Lead where id =:l2.Id limit 1];

        system.assertEquals('VSA',us.VSRegion__c);
        system.assertEquals('VSE',uk.VSRegion__c);
        
    }
}