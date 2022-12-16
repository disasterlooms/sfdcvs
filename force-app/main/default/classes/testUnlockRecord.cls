@isTest
private class testUnlockRecord {
     @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }

	@isTest static void testUnLock(){
		list<id> acctIds = new List<Id>();
            
        for(opportunity a : [Select id from opportunity limit 3]){
            acctIds.add(a.Id);
        }
		unlockRecordsInv.UnLockRecord(acctIds);
    }
}