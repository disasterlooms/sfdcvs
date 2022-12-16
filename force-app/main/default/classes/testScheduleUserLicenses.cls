@IsTest(SeeAllData=true)
//this is a class for api to EA so need to do see all data
private class testScheduleUserLicenses{
     public static String CRON_EXP = '0 0 0 15 3 ? 2022';   
    static testmethod void schuserLicensetest() {        
        test.startTest();
        // Schedule the test job
        String jobId = System.schedule('scheduledposCYsch',
                                       CRON_EXP, 
                                       new scheduleUserLicenses());
        Test.stopTest();
    }
    
}