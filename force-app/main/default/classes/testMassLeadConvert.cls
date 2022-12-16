@isTest
private class testMassLeadConvert{
     public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void TestMassLead() {
        
        test.startTest();
        Contact c = [Select id,lastname,firstname ,email,account.name,accountid from contact limit 1 ];
        Lead l = new Lead();
        l.lastname = c.lastname;
        l.firstname = c.firstname;
        l.company = c.account.name;
        l.email = 'testemailsand@vmail.com';
        l.industry = 'business';
        l.account_type__c = 'VAR';
        l.account__c = c.AccountId;
        l.Country = 'United States';
        insert l;
        
        
        // Schedule the test job
        massLeadConvert uca = new massLeadConvert();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        
        
        
    }
}