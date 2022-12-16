@isTest
public class testSchedAccOwners {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    public static testmethod void testWebService() {
        
        test.startTest();
        
        List<Account> acc = [Select id, TerritoryChange__c from Account limit 10];
        for(Account a : acc){
           a.TerritoryChange__c = true; 
        }
        update acc;
        
        accountTeamOwnersSchd abc = new accountTeamOwnersSchd(); 
        abc.execute(null);
        
        
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