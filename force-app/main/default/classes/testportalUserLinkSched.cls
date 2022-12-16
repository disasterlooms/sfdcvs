@isTest
public class testportalUserLinkSched {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    private static testmethod void testScheduleContactUsers(){
        
         test.startTest();       
        
         String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP,
            new queablePortalContactUserLink());
        
        test.stopTest();
        
    }
}