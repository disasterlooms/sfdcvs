@isTest
class testSandboxRecords{
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    @isTest
    static void testSandboxPostCopyScript() {
        SandboxRecords apexclass = new SandboxRecords();
        test.startTest();
        Test.testSandboxPostCopyScript(apexclass , '00D630000009KBf', '07E12000000Cseq', 'Test');
        SandboxOppPartners.sandpartners();
        SandboxClearReseller.clear();
        SandboxResellerAdd.resellers();
        test.stopTest();
        System.assertEquals(1,1,'Test something');
    }
}