@IsTest
//this is a class for api to EA so need to do see all data
private class testSchBatchSerialsSpiffs{
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';   
    static testmethod void schposCYtest() {        
        test.startTest();
        // Schedule the test job
        // 
        String vsacctid = [Select id from account where name = 'ViewSonic Corporation' limit 1].Id;
        Spiff_request__c spiff = [Select id, name from Spiff_request__c  
                                   where End_User__c != null limit 1];
        
        Asset ass = new Asset();
        ass.Spiff_Request__c = spiff.Id;
        ass.accountId = vsacctid;
        ass.SerialNumber = 'test12342347029348023';
        ass.name = 'test12342347029348023';
        insert ass;
        
        
        String jobId = System.schedule('schSerialsSpiffs',
                                       CRON_EXP, 
                                       new schBatchSerialsEndUserResellerSpiffs());
        Test.stopTest();
    }
    
    
}