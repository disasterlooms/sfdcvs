@isTest
private class TestSpaVipProduct {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
  
    static testmethod void accountVIP()
    {		        
        test.startTest();
        quote a = [Select Id   from Quote limit 1];
        String recid = a.Id;        
        AccountVIP.getRecord(recid);
        test.stopTest();
    }
}