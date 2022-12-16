@isTest
private class testUpdateAccountOwnerLWC {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void testupdatingAccount() {        
        String acctId = [Select id from account limit 1].Id;
        updateAcctOwnerLWC.getCorrectOwner(acctId);        
    }
}