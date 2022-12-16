({
	getPOInformation : function(cmp, event, helper) {
        var acc = cmp.get("v.acct");
        var poaction = cmp.get("c.getPurchaseOrder");
        poaction.setParams({
            "acct": acc
        });
        poaction.setCallback(this, function(data) {
            console.log('acct for shipping info');
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                var orders = data.getReturnValue();
                console.log('valid ship ins' + orders );
                if(orders.length > 0){
                    cmp.set("v.orders",orders);
                    cmp.set("v.ponumber",orders[0].PO_Number__c);
                    console.log('valid ship ins' + orders[0].PO_Number__c );
                }else{
                    console.log('No errors but no orders found');
                    cmp.set("v.noorders",'Sorry, No Orders found. You can contact your sales rep for more information');
                }
               
                
            }else{
                console.log('No orders found');
                cmp.set("v.noorders",'Sorry, No Orders found. You can contact your sales rep for more information');
                
            }
        });
        
        $A.enqueueAction(poaction);
		
	}
})