@isTest
private class TestAcctAggrPosSerial{
     public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void TestposSerial() {
        
        test.startTest();
        Account ac = [Select id from account limit 1];
        
        Asset a = new Asset();
        a.AccountId = ac.Id;
        a.PurchaseDate = date.today().addDays(-4);
        a.Price = 400;
        a.name = 'seriarlnumb389';
        insert a;
        
        
         // Schedule the test job
        String jobId = System.schedule('ScheduledApexTestAcctAggrPosSerial',
                                       CRON_EXP, 
                                       new SchAcctAggrPOSSerial());
        Test.stopTest();
        
        
        
    }
}