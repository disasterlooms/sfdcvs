public class ordersMasterClass{
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Order> oldOrders;
    Map<Id, Order> newOrders;
    
    List<Order> OrdersToUpdate = new List<Order>();
    // This is the constructor
    // A map of the old and new records is expected as inputs
    public ordersMasterClass(
        Map<Id, Order> oldTriggerOrders, 
        Map<Id, Order> newTriggerOrders) {
            oldOrders = oldTriggerOrders;
            newOrders = newTriggerOrders;
        }
    public void  spaUpdated() {
        //if spa is added to order then the order items will be updated
        
        List<String> ordersToUpdate = new List<String>();
        for(Order o :  newOrders.values()){
            Order old  = oldOrders.get(o.Id);
            if(old.QuoteId != o.QuoteId && o.QuoteId != null){
                ordersToUpdate.add(o.Id);
            } 
        }
        
        List<OrderItem> odi = [Select id, order.quoteid, quotelineitemid, pricebookentryid,
                               Order.SpaNumber__c, 
                               order.pricebook2id, OrderId ,product2Id
                               from orderitem where orderid in : ordersToUpdate];
        
        system.debug('order quote id');
        if(odi.size()> 0){
            system.debug(odi[0].Order.quoteid);
        }else{
            system.debug('no order items found');
        }
        
        
        Map<Id,OrderItem> oi = new Map<Id,OrderItem>();
        
        masterOrderItemClass oc = 
            new masterOrderItemClass(oi,oi);	
        
        system.debug('orderprods found');
        system.debug(odi);
        oc.quoteLine(odi);
        
        
    }

    public void pricebookSet(List<order> records) {
        
        
        
        CustomerKeys__mdt k = [SELECT key__c, SiteEducationSite__c, Pricebook__c  FROM CustomerKeys__mdt  limit 1]; 
        String pricebk = k.Pricebook__c;
        List<Pricebook2> pb = [Select id from pricebook2 where name =: pricebk and isActive = true limit 1 ];
        
        List<String> orders = new List<String>();
        for(Order o : records){
            orders.add(o.SpaNumber__c);
            if(pb.size()>0){
                o.Pricebook2Id = pb[0].Id;
                
            }            
        }
        
        
        
        Map<String,Quote> oppAcct = new Map<String,Quote>();
        List<Id> accts = new List<Id> (); 
        for(Quote q : [Select id, name,OpportunityId,Opportunity.AccountId from quote where name in : orders]){
            oppAcct.put(q.Name, q);
        }
        
        for(Order o : records){
            
            system.debug(orders.size()+ ' size of orders list');
            system.debug(orders);
            if(oppAcct.containsKey(o.spanumber__c)){
                system.debug('orders has spa found');
                Quote q = oppAcct.get(o.spanumber__c);
                system.debug('Account and opp ' +o.SpaNumber__c+' '+q.OpportunityId+' '+q.Opportunity.AccountId );
                o.AccountId = q.Opportunity.AccountId;
                o.Opportunity__c = q.OpportunityId;
                o.QuoteId = q.Id;
                accts.add(q.Opportunity.AccountId);
            }
        }
        
        Map<String,Order> relatedorders = new Map<String,Order>();
        for(order o : [Select  id, AccountId, Devices_Students_Use__c ,Devices_You_Use__c ,
                       What_Browsers_do_you_Use__c , What_type_of_Casting_would_you_like__c , 
                       Which_do_you_want_to_focus_on__c from order where accountid in: accts]){
                           relatedorders.put(o.accountId, o);
                           
                  }
        
        for(Order rod : records){
            if(relatedorders.containsKey(rod.AccountId)){
                Order o = relatedorders.get(rod.Accountid);
                rod.Devices_Students_Use__c = o.Devices_Students_Use__c;
                rod.Devices_You_Use__c = o.Devices_You_Use__c;
                rod.What_Browsers_do_you_Use__c = o.What_Browsers_do_you_Use__c;
                rod.What_type_of_Casting_would_you_like__c = o.What_type_of_Casting_would_you_like__c;
                rod.Which_do_you_want_to_focus_on__c = o.Which_do_you_want_to_focus_on__c;
            }
            
        }

        
    }
}