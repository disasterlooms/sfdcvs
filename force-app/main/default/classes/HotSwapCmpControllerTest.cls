@isTest
public class HotSwapCmpControllerTest {
    @testSetup
    public static void createdata ()
     {
       BuildTestData.AddRecords();        
    }
    
    static testMethod void getUpdateSpaProductsTest() { 
           test.startTest();
        Product2 prodstate = new Product2(Name = 'statesyncApex Test', family = 'test family',List_Price__c=5.00, IsActive= true,ProductCode = 'test', Hot_Swap_Quantity__c='7',Product_Quantity_Sold__c='20');
           insert prodstate;
      //  Account acc=new Account(Name='abc',Account_Type__c='Distributor',CurrencyIsoCode='USD');
       // insert acc;
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
        
        //Opportunity_Partner__c opc=new Opportunity_Partner__c(
                                                     //   Partner_Account__c=acc.Id,
            										//	Opportunity__c=opp.Id	
                                                     //   );
       //insert opc;
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
       
            Hot_Swap__c newHotSwap=new Hot_Swap__c();
           newHotSwap.SPA__c=q.Id;
            newHotSwap.Recipient_Name__c='Recipient';
            newHotSwap.Recipient_Phone__c='6789342';
            newHotSwap.Recipient_Email__c='reci@gmail.com';
            newHotSwap.Reason_For_Hot_Swap__c='test reason';
            newHotSwap.Street__c='street';
            newHotSwap.State__c='state';
            newHotSwap.PostalCode__c='672';
            newHotSwap.City__c='city';
            newHotSwap.Country__c='Country__c';
            newHotSwap.HotSwap_Product_Quantity__c= 'product-quantity';
 			newHotSwap.Hot_Swap_Products_Tracking_Id__c='product-quantity tracking';
            newHotSwap.Customer_Service_Action__c='Pending';
            insert newHotSwap;
        
        List<PricebookEntry> pb = [Select id from pricebookentry 
                             where pricebook2id = :opp.PriceBook2Id 
                             and isactive = true and id not in:olines ];
        
        QuoteLineItem lineitem = new QuoteLineItem(QuoteId = q.Id,
                                            Quantity = 3, 
                                            unitPrice = 300,
                                             Product2Id=prodstate.Id,
                                                 
                                            pricebookentryId = pbe);
         
        ///test
        insert lineitem;
        list<QuoteLineItem> qlList = new list<QuoteLineItem>();
        qlList.add(lineitem);
        
        test.stopTest();
        
        HotSwapCmpController.getSpaProducts(q.id);
        System.debug('Quote info'+q.id);
         System.debug('newHotSwap info'+newHotSwap);
         System.debug('qlList info'+qlList);
        System.debug('prodstate info'+prodstate);
       HotSwapCmpController.getUpdateSpaProducts(q.id,newHotSwap,qlList);
    }
     static testMethod void updateHotSwapFlagTest() { 
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
                            In_Approval_Review__c = true,
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
        
        QuoteLineItem lineitem = new QuoteLineItem(QuoteId = q.Id,
                                            Quantity = 3, 
                                            unitPrice = 300,
                                             Hotswap_Identification__c = true,
                                                  
                                            pricebookentryId = pbe);
         
        ///test
        insert lineitem;
         
         q.In_Approval_Review__c = false;
         q.Hot_Swap_Requested__c = true;
         update q;
         
        
        
        test.stopTest();
        
      
    }
    
     
     static testMethod void updateHotSwapFlagTest2() { 
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
                            In_Approval_Review__c = true,
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
        
        QuoteLineItem lineitem = new QuoteLineItem(QuoteId = q.Id,
                                            Quantity = 3, 
                                            unitPrice = 300,
                                             Hotswap_Identification__c = true,
                                            pricebookentryId = pbe);
         
        ///test
        insert lineitem;
         
         q.In_Approval_Review__c = false;
         update q;
        
        
        test.stopTest();
        
      
    }
    
}