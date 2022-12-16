@isTest
public class HttpCalloutGetURL_Test {
       @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
   static testmethod void testCallout() {
        
        String url = '';
        httpCalloutGetURL.getCalloutResponseContents(url);
        
    }
    
   static testmethod void getSpatest() {
        
       Quote q=new Quote();
       q=[Select id,OpportunityId,opportunity.AccountId,AccountId,Name from Quote limit 1];
        HttpCalloutGetURL.getSpa(q.Name);
    } 
}