@IsTest
public class testmobileSpaSearch  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void QuoteCreateLightning() {
        test.startTest();
        quotesMobile.getSpas('zz');
        test.stopTest();
        
    }
}