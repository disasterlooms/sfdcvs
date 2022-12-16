@isTest
private class TestSalesForceProjectTrigger{
    @testSetup
    private static void BuildTestData(){
        //BuildTestData.AddRecords();
    }
    static testmethod void ProjectcsTriggerUpdates() {
        Test.startTest();
        SalesforceProject__c p = new SalesforceProject__c(priority__c = 3,Status__c = 'Planned');
        insert p;

        TriggerContextUtility.setFirstRunTrue();
        SalesforceProject__c p2 = new SalesforceProject__c(priority__c = 4,Status__c = 'Planned');
        insert p2;

        TriggerContextUtility.setFirstRunTrue();        
        p.Priority__c = 4;
        update p;
        
        Test.stopTest();
    }
}