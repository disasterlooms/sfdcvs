({
	myAction : function(cmp, event, helper) {
        helper.spinnershow(cmp, event,helper);
        var action = cmp.get("c.getmonths");
        action.setCallback(this, function(data) {
        var rslt = data.getState();
       		if (rslt === "SUCCESS"){
            	cmp.set("v.months", data.getReturnValue());
                cmp.set("v.loading", null);    
                helper.spinnerhide(cmp, event,helper);    
            }else{
                helper.spinnerhide(cmp, event,helper); 
                cmp.set("v.loading", 'There was an issue with the query, please notify admin');
            }
        });
        $A.enqueueAction(action);
        var commit = cmp.find("commit");
        var comvalue = commit.get("v.checked");
        console.log(comvalue);
        
        var likely = cmp.find("likely");
        var likelyvalue = likely.get("v.checked");
        console.log(likelyvalue);
        
        var myopps = cmp.find("myopps");
        var myoppsvalue = myopps.get("v.checked");
        console.log(myoppsvalue);
        
        
        var prods = cmp.get("c.getSchedule");
        console.log('prod');
        console.log(cmp.get("v.product"));
        prods.setParams({"product": cmp.get("v.product"),
                          "reseller": cmp.get("v.reseller"),
                          "enduser": cmp.get("v.enduser"),
                          "industry": cmp.get("v.industry"),
                          "prodtype" : cmp.get("v.family"),
                          "srep" : cmp.get("v.rep"),
                         "likely" : likelyvalue,
                         "committed" : comvalue,
                         "myopps" : myoppsvalue
                        }); 
        prods.setCallback(this, function(data) {
        var rslt = data.getState();
       		if (rslt === "SUCCESS"){
            	cmp.set("v.lineitems", data.getReturnValue());
                cmp.set("v.loading", null);    
                helper.spinnerhide(cmp, event,helper);    
            }else{
                helper.spinnerhide(cmp, event,helper); 
                cmp.set("v.loading", 'There was an issue with the query, please notify admin');
            }
        });
        $A.enqueueAction(prods);
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