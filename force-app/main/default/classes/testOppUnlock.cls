@isTest
private class testOppUnlock {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
  
    static testmethod void getLines()
    {		        
        
        Opportunity q = [Select id from Opportunity limit 1];
        
		String oppid = q.Id;        
        
        test.startTest();
        OpportunityUnlock.unlockrec(oppid);
        test.stopTest();
    }
}