@isTest
public class TestacctOwnerUp {
     @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }

    public static testMethod void testMyController() {
        test.startTest(); 
        List<Account> ac = [select id from account];
        
        
        AccountUserTerritory2View at = [Select AccountId from AccountUserTerritory2View where AccountId in :ac limit 1];
        
        acctOwnerUp.ownerUp(at.Accountid);
        test.stoptest();
        
    }
}