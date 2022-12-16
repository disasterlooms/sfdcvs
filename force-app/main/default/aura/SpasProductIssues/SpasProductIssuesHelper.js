({
	helperMethod : function() {
		
	},
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide"); 
    },
    getProducts : function(cmp, event, helper) {
        var action = cmp.get("c.getOppLines");
        action.setParams({
            "quoteid":cmp.get("v.recordId"),
            "wherestmnt" : cmp.get("v.wherestmnt"),
            "addfields" : cmp.get("v.addfields"),
            "orderstmnt" : cmp.get("v.orderstmnt")
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                cmp.set("v.products",resp.getReturnValue());
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