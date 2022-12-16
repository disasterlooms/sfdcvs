@isTest
public class TestQuoteResubmission {
    @testSetup
    Private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void testEvalUnitstoQuote(){
        
        List<String> quoteid = new List<String>();
        Quote q = [Select id from quote limit 1];
        
        quoteid.add(q.Id+'some cool resub text to test');  
        
        test.startTest();
        
        QuoteResubmission.getRates(quoteid);
        
        
        test.stopTest();
    }
}