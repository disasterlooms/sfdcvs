@isTest
private class TestSpaStateSyncwithOpps {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }

    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testmethod void testScheduledJob() {

        // Create some out of date Opportunity records
        // 
        Test.startTest();
        Product2 prodstate = new Product2(Name = 'statesyncApex Test', family = 'test family',List_Price__c=5.00, IsActive= true);
           insert prodstate;
        
        PriceBookEntry pbEntrys = new PriceBookEntry(
                UnitPrice = 300,
                PriceBook2Id = Test.getStandardPricebookId() ,
                Product2Id = prodstate.Id,
                IsActive = true);
        
        insert pbEntrys;
        
        Opportunity opp = [Select Id, Pricebook2Id,End_User__c,
                           (Select PricebookEntryId from OpportunityLineItems where pricebookentry.isactive = true) from opportunity
                            where Id in (Select Opportunityid from OpportunityLineItem where pricebookentry.isactive = true) limit 1];
        
        String pbe = '';
           
        for(OpportunityLineItem oline : opp.OpportunityLineItems){
                
                pbe = oline.PricebookentryId;
            }
        
         PriceBookEntry pbEntry = new PriceBookEntry(
                UnitPrice = 300,
                PriceBook2Id = opp.Pricebook2Id ,
                Product2Id = prodstate.Id,
                IsActive = true);
        
        insert pbEntry;
        
        Quote q = new Quote(OpportunityId = opp.Id,
                           name = 'Apex Test',
                           Pricebook2Id = opp.PriceBook2Id,
                           StateSpaSync__c  = true,
                           Status = 'Needs Review');
        insert q;
        
        List<QuoteLineItem> lines = new List<QuoteLineItem>();
        
        QuoteLineItem qstatesync = new QuoteLineItem(QuoteId = q.Id,
                                            Quantity = 3, 
                                            unitPrice = 300,
                                            pricebookentryId = pbe,
                                            IsStateSpa__c  = true,
                                            SPA_Approval_Date__c = date.today());
        lines.add(qstatesync);
        
        QuoteLineItem qstatesyncopp = new QuoteLineItem(QuoteId = q.Id,
                                            Quantity = 3, 
                                            unitPrice = 300,
                                            pricebookentryId = pbEntry.Id,
                                            IsStateSpa__c  = true,
                                            SPA_Approval_Date__c = date.today());
        
        lines.add(qstatesyncopp);
        
        insert lines;
        
        TriggerContextUtility.setFirstRunTrue();
        
        for(QuoteLineItem l : lines){
            l.SPA_Approval_Date__c = date.today() -22;
            l.Approved_Price__c = 100;
        }       
        
        
        update lines;
        
        
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP, 
            new SpaStateSyncwithOpps());
        Test.stopTest();

    }
}