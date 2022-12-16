@isTest
private class TestTaskCampaignBatch {

    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testmethod void testTaskCampaignSchedule() {

        //Build test data for Accounts and Contacts
        BuildTestData.AddRecords();
        
        User u = [Select Id from User where LastName ='TestUserApex' limit 1];
        System.runAs ( u ) {
        Contact c = [Select Id from Contact where LastName='ApexTest' Limit 1];

        Task t = new Task(ActivityDate = Date.today().addDays(7),
							    Subject='Sample Task',
							    WhoId = c.Id,
							    OwnerId = u.Id,
							    Status='In Progress');

       insert t;

        // Get the IDs of the opportunities we just inserted
       
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP, 
            new TaskCampaignSchedule());

        //Task task = [Select Id, Campaign__c,CampaignCheck__c from task where id =:t.Id];
        //Boolean camp = t.CampaignCheck__c;

        //System.assertEquals(camp,true);

        // Verify the scheduled job has not run yet.
        Test.stopTest();
    }
        
    }
}