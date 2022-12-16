({
    getOpps : function(cmp,event,helper) {
        helper.toggle(cmp,event,helper);
        var action = cmp.get("c.getSpas");
        var ofields =  cmp.get("v.oppfields");
        var pfields =  cmp.get("v.prodfields");
        var states =  cmp.get("v.states");
        var products =  cmp.get("v.products");
        var accounts =  cmp.get("v.accounts");
        var industries =  cmp.get("v.industries");
        var ofset = cmp.get("v.ofset");
        var lmt = cmp.get("v.lmt");
        var field = cmp.get("v.sortfield");
        var dir = cmp.get("v.sortorder");
        var sort = field+' '+dir;
        var owners = cmp.get("v.owners");
        console.log('owners '+ owners);
        
        if(ofset == 0 ){
            var bkbtn = cmp.find("backbtn");
            bkbtn.set("v.disabled",true); 
        }else{
            var bkbtn = cmp.find("backbtn");
            bkbtn.set("v.disabled",false); 
        }
        
        console.log('ofields');
        console.log(ofields);
        console.log('pfields');
        console.log(pfields);
        console.log('record id');
        console.log(cmp.get("v.recordId"));
        action.setParams({
            "recid": cmp.get("v.recordId"),
            "ofields": ofields,
            "pfields": pfields,
            "states": states,
            "accounts": accounts,
            "products": products,
            "industries": industries,
            "ofset": ofset,
            "lmt" : lmt,
            "sorting" : sort,
            "owners" : owners
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                cmp.set("v.opps",response.getReturnValue());
                helper.hidespinner(cmp,event,helper);
                console.log('opps');
                console.log(response.getReturnValue());
                console.log('opps');
                
            }else if (state === "ERROR") {
                helper.hidespinner(cmp,event,helper);
                var errors = response.getError();
                if (errors) {
                    //$A.logf("Errors", errors);
                    if (errors[0] && errors[0].message) {
                        
                        console.log(' error'+errors[0].message);
                    }
                } else {
                    //$A.error("Unknown error");
                    helper.hidespinner(cmp,event,helper);
                    console.log(' unknown');
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinnerspa");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    hidespinner : function(cmp, event, helper) {
        //Toggle CSS styles for hiding Modal
        var cmpTarget = cmp.find("mySpinnerspa");
        $A.util.addClass(cmpTarget, 'slds-hide');
        
        
    }
})