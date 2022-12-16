@isTest
private class testBatchAssetSpaUpdate{
     public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void TestposSerial() {
        
        test.startTest();
        Account a = [Select id from account limit 1];
        Asset ass = new Asset();
        ass.AccountId = a.Id;
        ass.PurchaseDate = date.today();
        ass.name ='test';
        insert ass;
        batchAssetSpaNull b = new batchAssetSpaNull();
        database.executeBatch(b);
        Test.stopTest();
        
        
        
    }
}