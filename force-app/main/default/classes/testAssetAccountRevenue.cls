@isTest
private class testAssetAccountRevenue{
     public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void TestacctRevenue() {
        
        test.startTest();
        
        Account a = [Select id, aliasChange__c from Account limit 1];
        //a.assetChange__c = true;
        //update a;
            
        Asset ass = new Asset();
            ass.AccountId = a.id;
            ass.tp__c = 'taiesf';
            ass.purchasedate = date.today()-90;
            ass.price = 500;
            ass.Reseller_Account__c = a.Id;
            ass.serialnumber = '289962894186';
            ass.name = '289962894186';
            insert ass;
                         
       
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTestposSpaScheudle',
                                       CRON_EXP, 
                                       new schAssetAccountRevenue());
        Test.stopTest();
        
        
        
    }
}