@IsTest
public class TestMasterQuoteLineItems  {
   @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void pmapproved() {
        test.startTest();
        Product2 prodstate = new Product2(Name = 'statesyncApex Test', family = 'test family',List_Price__c=5.00, IsActive= true,ProductCode = 'test');
           insert prodstate;
        
        PriceBookEntry pbEntrys = new PriceBookEntry(
                UnitPrice = 300,
                PriceBook2Id = Test.getStandardPricebookId() ,
                Product2Id = prodstate.Id,
                IsActive = true
        	    );
         
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
        Set< Id> olines = new Set<Id>();        
        
        String pbe = '';
            for(OpportunityLineItem oline : opp.OpportunityLineItems){
                
                pbe = oline.PricebookentryId;
                olines.add(oline.PricebookEntryId);
            } 
       
               
        List<PricebookEntry> pb = [Select id from pricebookentry 
                             where pricebook2id = :opp.PriceBook2Id 
                             and isactive = true and id not in:olines ];
        
        List<QuoteLineItem> lineitems = new List<QuoteLineItem>();
        
        QuoteLineItem lineitem = new QuoteLineItem(QuoteId = q.Id,
                                            Quantity = 3, 
                                            unitPrice = 300,
                                            pricebookentryId = pbe);
        lineitems.add(lineitem);
        
        
        QuoteLineItem lineitem2 = new QuoteLineItem(QuoteId = q.Id,
                                            Quantity = 3, 
                                            unitPrice = 300,
                                            pricebookentryId = pb[0].Id);
         lineitems.add(lineitem2);
        
        insert lineitems;
        
        TriggerContextUtility.setFirstRunTrue();
        
        lineitems[0].Approved_Price__c = 350;
        lineitems[1].Approved_Price__c = 350;
        
        update lineitems;
        test.stopTest();
        
        
    }
}