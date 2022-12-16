@isTest
private class testPOSAliasApp {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void getAliases() {  
        
        Test.startTest();
        
        String aname = 'somename';
        POSAliasApp.getAliases(aname);
     
            
        Test.stopTest();
        
    }
    
}