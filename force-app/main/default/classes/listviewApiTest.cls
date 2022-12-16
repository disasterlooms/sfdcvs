@isTest
private class listviewApiTest {
    
    @isTest static void testAllAccountList() {
    
        List<Account> testAccounts = new List<Account>();
        for(integer i=0; i<100 ; i++){
            Account acc = new Account();
            acc.BillingCity = 'Apex City test' + i;
            acc.Name = 'Test Account'+ i;
            testAccounts.add(acc);
        }
        TriggerContextUtility.setFirstRunFalse();
        insert testAccounts;
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        PageReference pageRef = Page.exportStandardListView;
        Test.setCurrentPage(pageRef);
        listviewAPI listviewAPIctrl = new listviewAPI();
        pageRef.getParameters().put('listid', 'ert322144');
        pageRef.getParameters().put('Object', 'Account');
        pageRef.getParameters().put('listName', 'All Account');
        listviewAPIctrl.fetchListviewRecords();
        Test.StopTest();
        system.assertEquals(listviewAPIctrl.fileName,'Account_All_Account_'+Datetime.now().format());
        system.assertEquals(listviewAPIctrl.columnName[0],'Account Name');

    }

    @isTest static void testAllAccountList_error() {
    
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
                    System.runAs ( thisUser ) {

                UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
                    insert r;

                User u = new User(
                     ProfileId = [SELECT Id FROM Profile WHERE Name = 'SFDC Admin'].Id,
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
                     UserRoleId = r.Id,
                     IsActive = true
                ); 

                insert u;

       
        List<Account> testAccounts = new List<Account>();
        for(integer i=0; i<100 ; i++){
            Account acc = new Account();
            acc.Name = 'Test Account'+ i;
            acc.BillingCity = 'City'+ i;
            acc.Type = 'End User'+ i;
            acc.BillingState = 'ZZ';
            testAccounts.add(acc);
        }
        TriggerContextUtility.setFirstRunFalse();
        insert testAccounts;
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        PageReference pageRef = Page.exportStandardListView;
        Test.setCurrentPage(pageRef);
        listviewAPI listviewAPIctrl = new listviewAPI();
        pageRef.getParameters().put('listid', '');
        pageRef.getParameters().put('Object', '');
        listviewAPIctrl.fetchListviewRecords();
        Test.StopTest();
        system.assertNotEquals(listviewAPIctrl.fileName,'Account_All_Account_'+Datetime.now().format());
    }

    }
}