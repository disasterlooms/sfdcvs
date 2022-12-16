@isTest
private class TestUpdateLineItems {
	@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testmethod void testUpdateLineItems() {
       Test.Starttest();
        // Create products with landed cost updates needed
        List<Product2> prods = new List<Product2>();
        for (Integer i=0; i<10; i++) {
            Product2 p = new Product2 (
                Name = 'productcool' + i,
                Family = 'test apex family',
                List_Price__c = 25.00,
                Cost__c = 20.00,
                LandedCostChange__c = true
            );
            prods.add(p);
        }
        insert prods;
        
        /*
        OpportunityLineItem line= [Select id,MarginUpdate__c,OpportunityId from OpportunityLineItem where Product2.Name = 'Apex Test' Limit 1 ];
        
        Opportunity opp = [Select id from Opportunity where id =: line.OpportunityId];
        
        
        update opp;
        */
        Product2 p = [Select Id, Name,Cost__c from Product2 Where Name = 'Apex Test' Limit 1 ];
        p.Cost__c = 20;
        update p;
        
        
        // Get the IDs of the opportunities we just inserted
        Map<Id, Product2> opptyMap = new Map<Id, Product2>(prods);
        List<Id> opptyIds = new List<Id>(opptyMap.keySet());

       
        // Schedule the test job
        //String jobId = System.schedule('ScheduledApexTest',
            //CRON_EXP, 
            //new UpdateOppLineMargins());         
        // Verify the scheduled job has not run yet.
        Test.stopTest();
        
        // Now that the scheduled job has executed,
        // check that our tasks were created
        //lt = [SELECT Id 
            //FROM Task 
            //WHERE WhatId IN :opptyIds];
        //System.assertEquals(opptyIds.size(), 
            //lt.size(), 
            //'Tasks were not created');

    }
}