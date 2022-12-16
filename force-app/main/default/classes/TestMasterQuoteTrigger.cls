@IsTest
public class TestMasterQuoteTrigger  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    } 
    
    Static testmethod void QuoteCreateLightning() {
        test.startTest();
        Product2 prodstate = new Product2(Name = 'statesyncApex Test', family = 'test family',List_Price__c=5.00, IsActive= true);
        insert prodstate;
        
        PriceBookEntry pbEntrys = new PriceBookEntry(
            UnitPrice = 300,
            PriceBook2Id = Test.getStandardPricebookId() ,
            Product2Id = prodstate.Id,
            IsActive = true);
        
        insert pbEntrys;
        
        
        
        String recid ='';
        Opportunity opp = [Select Id,Pricebook2Id,End_User__c,
                           (Select PricebookEntryId from OpportunityLineItems where pricebookentry.isactive = true) from opportunity
                           where Id in (Select Opportunityid from OpportunityLineItem where pricebookentry.isactive = true) limit 1];
        recid = opp.Id;
        OppQuote.getSpas(recid);
        
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
        
        
        Quote qfirst = new Quote(OpportunityId = opp.Id,
                                 name = 'Apex Test',
                                 Pricebook2Id = opp.PriceBook2Id,
                                 StateSpaSync__c  = true,
                                 Status = 'Needs Review',
                                 First_Time_Buyer__c = true);
        insert qfirst;
        
        //Quote q = [Select id,pricebook2id from Quote Limit 1];
        
        String pbe = '';
        for(OpportunityLineItem oline : opp.OpportunityLineItems){
            
            pbe = oline.PricebookentryId;
        }    
        
        
        
        TriggerContextUtility.setFirstRunTrue();
        
        
        
        TriggerContextUtility.setFirstRunTrue();
        q.ExpirationDate = date.today();
        update q;        
        TriggerContextUtility.setFirstRunTrue();
        
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
        }       
        
        
        update lines;
        
        TriggerContextUtility.setFirstRunTrue();
        
        q.Status = 'Approved';
        update q;
        
        TriggerContextUtility.setFirstRunTrue();
        
        QuoteLineItem qapproved = new QuoteLineItem(QuoteId = q.Id,
                                                    Quantity = 3, 
                                                    unitPrice = 300,
                                                    pricebookentryId = pbe,
                                                    IsStateSpa__c  = true,
                                                    SPA_Approval_Date__c = date.today());
        insert qapproved;
        
        test.stopTest();
        
    }
    Static testmethod void QuoteInactive() {
        test.startTest();
        Product2 prodstate = new Product2(Name = 'statesyncApex Test', family = 'test family',List_Price__c=5.00, IsActive= true);
        insert prodstate;
        
        PriceBookEntry pbEntrys = new PriceBookEntry(
            UnitPrice = 300,
            PriceBook2Id = Test.getStandardPricebookId() ,
            Product2Id = prodstate.Id,
            IsActive = true);
        
        insert pbEntrys;
        
        
        
        String recid ='';
        Opportunity opp = [Select Id,Pricebook2Id,End_User__c,
                           (Select PricebookEntryId from OpportunityLineItems where pricebookentry.isactive = true) from opportunity
                           where Id in (Select Opportunityid from OpportunityLineItem where pricebookentry.isactive = true) limit 1];
        recid = opp.Id;
        OppQuote.getSpas(recid);
        
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
        
        Quote qfirst = new Quote(OpportunityId = opp.Id,
                                 name = 'Apex Test',
                                 Pricebook2Id = opp.PriceBook2Id,
                                 Status = 'Needs Review');
        insert qfirst;
        
        //Quote q = [Select id,pricebook2id from Quote Limit 1];        
        
        TriggerContextUtility.setFirstRunTrue();
        q.Active__c = false;
        update q;
        
        TriggerContextUtility.setFirstRunTrue();
        qfirst.active__c = true;        
        qfirst.Resubmission_Notes__c = 'new notes';
        update q;
        
        
        test.stopTest();
    }
}