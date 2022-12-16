@IsTest(SeeAllData=true)
//this is a class for api to EA so need to do see all data
private class testschposCY{
     public static String CRON_EXP = '0 0 0 15 3 ? 2022';   
    static testmethod void schposCYtest() {        
        test.startTest();
        // Schedule the test job
        String jobId = System.schedule('scheduledposCYsch',
                                       CRON_EXP, 
                                       new posCYsch());
        Test.stopTest();
    }
    
    static testmethod void schposPYtest() {        
        test.startTest();
        // Schedule the test job
        String jobId = System.schedule('scheduledposCYsch',
                                       CRON_EXP, 
                                       new posPYsch());
        Test.stopTest();
    }
    
}