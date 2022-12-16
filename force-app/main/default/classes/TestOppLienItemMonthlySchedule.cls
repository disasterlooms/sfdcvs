@isTest
private class TestOppLienItemMonthlySchedule {

    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
     @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void testScheduledJob() {


        Test.startTest();
         opportunitylineitem opp = [select id,product2Id,product2.CanUseQuantitySchedule  from opportunitylineitem limit 1];
        
        product2 p = [Select id,CanUseQuantitySchedule from product2 where id =: opp.product2Id limit 1 ];
        
        p.CanUseQuantitySchedule = true;
        update p;
        
        OpportunityLineItemSchedule s = new OpportunityLineItemSchedule(type ='quantity',
                                                                       opportunitylineitemid = opp.id,
                                                                       ScheduleDate = date.today(),
                                                                       Quantity = 10);
        insert s;
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP, 
            new OppLineItemMonthlySchedule());
        
        // Stopping the test will run the job synchronously
        Test.stopTest();

    }
}