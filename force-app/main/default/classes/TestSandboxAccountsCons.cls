@IsTest
public class TestSandboxAccountsCons  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void testaccountcons() {
        test.startTest();
        SandboxAccounts.addaccts();
        SandboxAccounts.addcontacts();
        test.stopTest();            
    }
}