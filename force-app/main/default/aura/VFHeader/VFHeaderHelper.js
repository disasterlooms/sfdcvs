({
	myAction : function(cmp, event, helper) {
        helper.spinnershow(cmp, event,helper);
        var action = cmp.get("c.getOpps");
        console.log('searhc industry');
        console.log(cmp.get("v.industry"))
        action.setParams({"product": cmp.get("v.product"),
                          "reseller": cmp.get("v.reseller"),
                          "enduser": cmp.get("v.enduser"),
                          "industry": cmp.get("v.industry"),
                          "prodtype" : cmp.get("v.family"),
                          "sreps" : cmp.get("v.rep")});
        action.setCallback(this, function(data) {
        var rslt = data.getState();
       		if (rslt === "SUCCESS"){
            	cmp.set("v.opportunities", data.getReturnValue());
                cmp.set("v.loading", null);    
                helper.spinnerhide(cmp, event,helper);    
            }else{
                helper.spinnerhide(cmp, event,helper); 
                cmp.set("v.loading", 'There was an issue with the query, please notify admin');
            }
        });
        $A.enqueueAction(action);
	},
    spinnershow : function(cmp,event,helper){
       //var spinner = cmp.find("mySpinner");
       //$A.util.toggleClass(spinner, "slds-hide");
       var spinner = document.getElementById("spinnerdiv");
       $A.util.removeClass(spinner, "hideme"); 
    },
    spinnerhide : function(cmp,event,helper){
       //var spinner = cmp.find("mySpinner");
       //$A.util.toggleClass(spinner, "slds-hide");
       var spinner = document.getElementById("spinnerdiv");
       $A.util.addClass(spinner, "hideme"); 
    }
})