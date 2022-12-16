@isTest
private class testpp_schOnboardingTaks{
     public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void TestposSerial() {
        
        test.startTest();
        Contact con = [Select id from contact limit 1];
        Portal_Task__c  pt = new Portal_Task__c ();
        pt.Required__c = false;
        pt.Name = 'w9test';
        insert pt;
        
        
        PortalOnboardingProgress__c pp = new PortalOnboardingProgress__c();
        pp.Portal_Contact__c = con.Id;
        pp.Partner_Portal_Task__c = pt.Id;
        insert pp;      
        
        
         // Schedule the test job
        String jobId = System.schedule('ScheduledApexTestAcctAggrPosSerial',
                                       CRON_EXP, 
                                       new pp_schOnboardingTaks());
        Test.stopTest();
        
        
        
    }
}