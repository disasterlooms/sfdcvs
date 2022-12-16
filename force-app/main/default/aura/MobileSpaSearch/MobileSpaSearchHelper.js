({
	getSpas : function(cmp,event,helper) {
        helper.toggle(cmp, event,helper);
        var action = cmp.get("c.getSpas");
        action.setParams({"searchtxt": cmp.get("v.searchinput")});
        action.setCallback(this, function(data) {
        cmp.set("v.spas", data.getReturnValue());
        	var rslt = data.getState();
            if (rslt === "SUCCESS"){
                //cmp.set("v.load" , false);
                helper.toggle(cmp, event,helper); 
            }else{
                helper.toggle(cmp, event,helper); 
                alert('There were some errors on the search');
            }
               
        });
        $A.enqueueAction(action); 
		
	},
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinnerspas");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    
})