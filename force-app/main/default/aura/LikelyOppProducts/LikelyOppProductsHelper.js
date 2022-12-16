({	
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide"); 
    },
    getProducts : function(cmp, event, helper) {
        var action = cmp.get("c.getOppLInes");
        action.setParams({
            "oppid":cmp.get("v.recordId")
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                cmp.set("v.products",resp.getReturnValue());
            }
            else{
                alert(resp.getError());
            }
        });
        
        $A.enqueueAction(action);
        var saction = cmp.get("c.getStatus");
        saction.setCallback(this, function(data) {
            cmp.set("v.status", data.getReturnValue());
        });
        
        $A.enqueueAction(saction);
    }
})