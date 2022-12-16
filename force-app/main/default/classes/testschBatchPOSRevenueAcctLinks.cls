@isTest
private class testschBatchPOSRevenueAcctLinks{
     public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void TestPosRevenueAcctLink() {
        
        test.startTest();
        
        Account acc = [Select id from account limit 1];
        
        POS_Revenue__c pr = new POS_Revenue__c();
        pr.Account_Name__c = acc.Id;
        pr.Name = 'test name';
        pr.CY_Revenue__c = 900;
        
        insert pr;


        
         // Schedule the test job
        String jobId = System.schedule('ScheduledApexTestposSpaScheudle',
                                       CRON_EXP, 
                                       new schBatchPOSRevenueAccountLink());
        Test.stopTest();
        
        
        
    }
}