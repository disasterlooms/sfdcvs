@isTest
private class TestOppProducts {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void getStatus()  
    {
        test.startTest();
        OppProducts.getStatus();
        test.stopTest();
    }
    
    static testmethod void getOppLInes()
    {		        
        
        test.startTest();
        Product2 prodstate = new Product2(Name = 'statesyncApex Test', family = 'test family',List_Price__c=5.00, IsActive= true);
        insert prodstate;
        
        PriceBookEntry pbEntrys = new PriceBookEntry(
            UnitPrice = 300,
            PriceBook2Id = Test.getStandardPricebookId() ,
            Product2Id = prodstate.Id,
            IsActive = true);
        
        insert pbEntrys;
        
        TriggerContextUtility.setFirstRunTrue();
        
        prodstate.CanUseQuantitySchedule = true;
        update prodstate;
        
        List<Opportunity> opp  = [Select Id,Opportunity.Pricebook2Id,(Select Id,product2.name,Quantity,Ship_Out_Date__c,Product2Id,
                                                                      OpportunityId,unitprice,Status__c,TotalPrice from OpportunityLineItems) from Opportunity where HasOpportunityLineItem = true limit 2];
        
        PriceBookEntry pbEntry = new PriceBookEntry(
            UnitPrice = 300,
            PriceBook2Id = opp[0].Pricebook2Id ,
            Product2Id = prodstate.Id,
            IsActive = true);
        
        insert pbEntry;
        
        OpportunityLineItem oline = new OpportunityLineItem(OpportunityId = opp[0].Id,
                                                            PricebookEntryId = pbEntry.Id,
                                                            Quantity = 10,
                                                            UnitPrice = 100);
        insert oline;
        
        
        
        
        List<OpportunityLineItem> lineitems = new List<OpportunityLineItem>();
        lineitems.add(oline);
        Set<String> lineproducts = new Set<String>();
        
        if(opp[0].opportunitylineitems.size() > 0 ){
            
            lineitems.add(opp[0].OpportunityLineItems[0]);
            
            for(OpportunityLineItem l : lineitems){
                lineproducts.add(l.Product2Id);
            }
            
            List<Product2> prods = [Select id ,CanUseQuantitySchedule from Product2 where Id in :lineproducts];
            
            TriggerContextUtility.setFirstRunTrue();
            for(Product2 p : prods){
                p.CanUseQuantitySchedule = true;
                update p; 
            }
            
            
            lineitems[0].Ship_Out_Date__c = null;
            update lineitems[0];
            
            OpportunityLineItemSchedule sch = new OpportunityLineItemSchedule(OpportunityLineItemId = lineitems[0].Id,
                                                                              Quantity = 30,
                                                                              ScheduleDate = date.today(),
                                                                              Type = 'Quantity');
            insert sch;
            
            
        }
        if(opp[0].opportunitylineitems.size() > 1 ){
            lineitems.add(opp[0].OpportunityLineItems[1]);
        }
        
        
        
        //methods getOpp getUser updateopps getSpas
        //setting the variables need to pass to method get spas
        
        String oppid  = opp[0].Id;
        
        //test method for account, contact or opportunity object as record id
        
        lineitems = OppProducts.getOppLInes(oppid);
        OppProducts.updateOppLines(lineitems,oppid);
        
        lineitems[0].Ship_Out_Date__c = date.today();
        update lineitems[0];
        
        OpportunityLineItemSchedule sch = new OpportunityLineItemSchedule(OpportunityLineItemId = lineitems[0].Id,
                                                                              Quantity = 30,
                                                                              ScheduleDate = date.today(),
                                                                              Type = 'Quantity');
        insert sch;
        
        OppProducts.updateOppLines(lineitems,oppid);
        OppProducts.deleteOppLines(lineitems,oppid);
        
        test.stopTest();
    }
}