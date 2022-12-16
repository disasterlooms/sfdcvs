@isTest
private class testportalGroupVerified{
    //add test build..will still have some custom records created 
    //but this base of records will allow scalibility for this test without
    //having to create multiple records and update when validation rules
    //or picklists changes are made to the metadata
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void ContactTrigger() {
        test.startTest();
        Account a = [Select id, isPartner,(Select id from Contacts) from account where Type != 'End User' and id in (Select accountid from contact) limit 1];
	    a.IsPartner = true;
        update a;
        
        User u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Partner Community Login Unverified'].Id,
                LastName = 'last testingapex',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST Apex',
                Title = 'title',
                Country = 'United States',
                Phone = '5625551212',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                IsActive = true,
                ContactId = a.Contacts[0].Id
            ); 
        insert u;
                
        Set<Id> records = new Set<Id>();
        Contact con = [Select id from contact where id in (Select contactid from user) limit 1];
        records.add(con.Id);
        System.enqueueJob( new portalGroupVerified(records)); 
        
        test.stopTest();

    }
}