@isTest
class testSandboxResellerRecords{
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    @isTest
    static void testSandboxPostCopyScript() {
        SandboxRecords apexclass = new SandboxRecords();
        test.startTest();
        SandboxOppPartners.sandpartners();
        SandboxClearReseller.clear();
        SandboxResellerAdd.resellers();
        test.stopTest();
    }
}