@isTest
public class GovSpendContactComponentControllerTest {

    @isTest
    static void test_Success(){
    
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('https://app.govspend.com/runSavedSearch', 'GovSpend_runSavedSearch_Success');
        multimock.setStaticResource('https://app.govspend.com/exportCreditStats?searchId=ABC123', 'GovSpend_exportCreditStats_Success');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, multimock);
       	Test.startTest();
        GovSpendContactComponentController.doMappingSync('ABC123');
        Test.stopTest();
		GovSpendContactComponentController.getCredits('ABC123');
    
    }
    
}