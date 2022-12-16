@isTest
private class TestposSerialBatch{
     public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void TestposSerial() {
        
        test.startTest();
        Opportunity o = [Select id, SPA_ID__c from Opportunity limit 1];
        
        List<PosSerialNumber__c> psn = new List<PosSerialNumber__c>();
            PosSerialNumber__c posser = new PosSerialNumber__c();
            	posser.Distributor__c = 'test ';
                posser.Product__c = 'test';
                posser.Reseller__c = 'test';
                posser.Revenue__c = 300;
                posser.SaleDate__c = date.today();
                posser.Serial_Number__c = '33832-092387test';
                posser.SpaId__c = o.SPA_ID__c;
            
            psn.add(posser);
            
            insert psn;
        
         // Schedule the test job
        String jobId = System.schedule('ScheduledApexTestposSpaScheudle',
                                       CRON_EXP, 
                                       new posSpaSchedule());
        Test.stopTest();
        
        
        
    }
}