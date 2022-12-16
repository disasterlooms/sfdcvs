@isTest
private class TestEvalsEmailPastDueManger {
	@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
	public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testmethod void EvalsEmailPastDueManager() {
       
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP, 
            new EvalsEmailPastDueManager());

        Test.stopTest();
     }
	
}