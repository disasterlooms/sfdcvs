@isTest
public class testRunTerritoryRules {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    public static testmethod void testWebService() {
        
        test.startTest();
        Account acc = [select id from account limit 1];
        
        /*
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            
            
            mock.setStaticResource('NameOfStaticResourceContainingResponseBodyString');
            
            
            mock.setStatusCode(200); // Or other appropriate HTTP status code
            mock.setHeader('Content-Type', 'application/json'); // Or other appropriate MIME type like application/xml
            Test.setMock(HttpCalloutMock.class, mock);
            
            */
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        schedTerritoryRules abc = new schedTerritoryRules(); 
        abc.execute(null);
        
        //RunTerritoryRules job = new RunTerritoryRules() ;
        //job.accntIds = new Set<String>{acc.Id}; 
        System.enqueueJob(new RunTerritoryRules(new Set<String>{acc.Id}));
        
        test.stopTest();
        
        /*  The commented code is left as tools to get a test class that performs mock web service calls
         * at last attempts, could not get mock callout to work so will need to come back to this. 

            RunTerritoryRules controller = new RunTerritoryRules();
            // Invoke the continuation by calling the action method
            //Continuation conti = (Continuation)controller.startRequest();
            controller.startRequest();
            // Verify that the continuation has the proper requests
            Map<String, HttpRequest> requests = controller.getRequests();
            
            // Perform mock callout 
            // (i.e. skip the callout and call the callback method)
            HttpResponse response = new HttpResponse();
            response.setBody('Mock response body');   
            // Set the fake response for the continuation     
            Test.setContinuationResponse(controller.requestLabel, response);
            // Invoke callback method
            Object result = Test.invokeContinuationMethod(controller);
            // result is the return value of the callback
            // 
            */
    }
}