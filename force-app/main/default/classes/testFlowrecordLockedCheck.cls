@isTest
private class testFlowrecordLockedCheck {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    @isTest
    static void testpricingSearch(){  
        test.startTest();
        opportunity u = [Select id from opportunity limit 1];
        recordLockedFlowCheck.checkLocked(u.Id);
        test.stopTest();
        
    }
}