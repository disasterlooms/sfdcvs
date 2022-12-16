@isTest
private class testPortalOnboardTasks {
     @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    @isTest
    static void testAssignment(){
        test.startTest();
		Contact c = [Select id from contact limit 1];
        Portal_Task__c pt = new Portal_Task__c();
        pt.Active__c = true;
        pt.Required__c = true;
        pt.Type__c = 'Onboarding';
        insert pt;
        String conId = c.Id;
        portalOnboardingAssignTask.assignTaks(conId); 
        test.stopTest();
        
    }
}