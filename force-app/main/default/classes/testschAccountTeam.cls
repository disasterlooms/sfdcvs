@isTest
private class testschAccountTeam {
    
    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void testschAccountTeam() {
        
        List<Account> accs = [Select id, Acct_Team_Check__c from account];
        for(Account a : accs){
            a.Acct_Team_Check__c = true;
        }
        database.update(accs, false);
        
        
        // Get the IDs of the opportunities we just inserted
        
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
                                       CRON_EXP, 
                                       new schAccountTeam());
        
        Test.stopTest();
    }
    
}