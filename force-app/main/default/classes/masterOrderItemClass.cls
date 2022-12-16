public class masterOrderItemClass{
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, OrderItem> oldOrderItem;
    Map<Id, OrderItem> newOrderItem;
    List<OrderItem> OrdersToUpdate = new List<OrderItem>();
    
    // This is the constructor
    // A map of the old and new records is expected as inputs
    public masterOrderItemClass(
        Map<Id, OrderItem> oldTriggerOrderItem, 
        Map<Id, OrderItem> newTriggerOrderItem) {
            oldOrderItem = oldTriggerOrderItem;
            newOrderItem = newTriggerOrderItem;
        }
    
    public void quoteLine(List<OrderItem> records) {
        
        
        Set<String> spas = new Set<String>();
        for(OrderItem o : records){
            spas.add(o.order.quoteid);
            spas.add(o.orderId);            
        }
        system.debug('strings');
        system.debug(spas);
        
        List<Order> ordersToQuery = [Select id,quoteid from Order where id in : spas  or SpaNumber__c in: spas];
        for(Order o: ordersToQuery){
            spas.add(o.QuoteId);   
        }
        
        Map<String, QuoteLineItem> ordprods = new Map<String, QuoteLineItem> ();
        for(QuoteLineItem q : [Select Quoteid, Id, Quote.Name, product2Id,product2.name from quotelineitem where quoteId in 
                               : spas order by createddate desc]){
                                   String qid = q.QuoteId;
                                   String pid = q.product2Id;                        
                                   ordprods.put(qid+pid, q);
                               }
        system.debug('ordprods');
        system.debug(ordprods);
        
        Map<Id, Order> ord = new Map<Id, Order> ();
        for(Order od : [Select id, QuoteId from order where id in : spas ]){
            ord.put(od.Id , od);
        }
        
        system.debug('order item');
        system.debug(records);
        for(OrderItem o : records){
            if(ord.containsKey(o.OrderId)){
                String odId = ''; 
                system.debug('order.Id');
                Order odd = ord.get(o.OrderId);
                odId = odd.QuoteId;
                system.debug('quoteid');
                system.debug(odId);                
                system.debug('prduct');
                system.debug(o.product2id);                
                if(ordprods.containsKey(odId+o.product2id)){
                    QuoteLineItem q = ordprods.get(odId+o.product2id);
                    o.QuoteLineItemId = q.Id;
                }
            }
            
        }
        
        /*

        *** Important *** 
        This is because we are using this class for multiple items and it will get an error if in
        Insert trigger for the order items but will not get an error when running from the order trigger context 
        
        */    
        
        if( !trigger.isInsert){
            update records;
        }
        
        
    }
}