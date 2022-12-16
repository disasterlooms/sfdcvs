({
	getSpas : function(cmp, event, helper) {
        cmp.set("v.load" , true);
        helper.showspinner(cmp, event,helper); 
        var action = cmp.get("c.getSpas");
        action.setParams({"product": cmp.get("v.product"),
                          "reseller": cmp.get("v.reseller"),
                          "enduser": cmp.get("v.enduser"),
                          "industry": cmp.get("v.industry"),
                          "family": cmp.get("v.family"),
                          "ofields": cmp.get("v.ofields"),
            			  "pfields": cmp.get("v.pfields"),
                          "spaid": cmp.get("v.spaid")});
        action.setCallback(this, function(data) {
        cmp.set("v.opportunities", data.getReturnValue());
        	var rslt = data.getState();
            if (rslt === "SUCCESS"){
                cmp.set("v.load" , false);
                helper.hidespinner(cmp, event,helper); 
            }else{
                helper.hidespinner(cmp, event,helper); 
                alert('There were some errors on the search');
            }
               
        });
        $A.enqueueAction(action);
	},
    showspinner: function (cmp, event,helper) {
        var spinner = cmp.find("spinnerspa");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hidespinner: function (cmp, event,helper) {
        var spinner = cmp.find("spinnerspa");
        $A.util.addClass(spinner, "slds-hide");
    }
})