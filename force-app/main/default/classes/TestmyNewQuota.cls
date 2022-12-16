@isTest
private class TestmyNewQuota {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void getPicklists()  
    {
        
        List<Quota__c> quotas = new List<Quota__c>();
        
        myNewQuota.getReps();
        myNewQuota.myFields();
        myNewQuota.createQuotas(quotas);
        
    }
    
}