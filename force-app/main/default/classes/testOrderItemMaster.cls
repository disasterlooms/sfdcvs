@isTest
private class testOrderItemMaster{
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void orderTrigger() {        
        test.startTest();
                
        Order ordTest = [Select id,QuoteId, opportunity__c,AccountId,SpaNumber__c , Pricebook2Id  from Order where quoteId != null limit 1];
        List<QuoteLineItem> q = [Select id, QuoteId , product2id,pricebookentryId,quote.Pricebook2Id,unitprice  from QuoteLineItem where quoteid =: ordTest.QuoteId
                                 order by createddate desc];
        system.debug('quotelines '+q.size());
                system.debug(q);

        
        ordTest.Pricebook2Id  = q[0].quote.Pricebook2Id;
        update ordTest;
        
        OrderItem oi = new OrderItem();
        oi.quantity = 1;
        oi.pricebookentryId = q[0].pricebookentryId;
        oi.OrderId = ordTest.Id;
        oi.unitprice = q[0].unitprice;
        
        insert oi;
        
        ordTest.QuoteId = null;
        ordTest.SpaNumber__c = '';
        update ordTest;
        
        OrderItem oi2 = new OrderItem();
        oi2.quantity = 1;
        oi2.pricebookentryId = q[0].pricebookentryId;
        oi2.OrderId = ordTest.Id;
        oi2.unitprice = q[0].unitprice;
        TriggerContextUtility.setFirstRunTrue();
        insert oi2;
        
        
        test.stopTest();
        
        order ott = [Select id, quoteid from order where id = : ordTest.Id];
        system.assertEquals(null, ott.quoteid);
        //OrderItem oit = [Select id, quotelineitemId from orderitem where id = : oi.Id and product2id = : q[0].product2id and 
                         //Order.QuoteId =: q[0].QuoteId ];
        
        //system.assertNotEquals(oit.quotelineitemId,null);
        
        
    }
}