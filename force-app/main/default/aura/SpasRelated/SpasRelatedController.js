({
	myAction : function(component, event, helper) {
		
	},
    getProducts : function(cmp, event, helper) {
        var action = cmp.get("c.getspas");
        action.setParams({
            "quoteid":cmp.get("v.recordId")
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                cmp.set("v.quotes",resp.getReturnValue());
                if(resp.getReturnValue().length > 0){
                    cmp.set("v.showProds",true);
                }else{
                     cmp.set("v.showProds",false);
                }
            }
            else{
                alert(resp.getError());
            }
        });
        
        $A.enqueueAction(action);
    }
})