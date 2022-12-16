({
    helperMethod : function() {
        
    },
    closeModal :function(cmp,event,helper){
        cmp.find("overlayLib").notifyClose();
    },
    getSchdule : function(cmp, event, helper) {
        //var myPageRef = cmp.get("v.pageReference");
        //var lid = myPageRef.olineId;
        //cmp.set("v.lineid", lid);
        
        console.log('action');
        
        var action = cmp.get("c.getmonths");
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                cmp.set("v.months", data.getReturnValue());
                //cmp.set("v.loading", null);
                console.log('monts '+data.getReturnValue());
                //helper.spinnerhide(cmp, event,helper);    
            }else{
                //helper.spinnerhide(cmp, event,helper); 
                cmp.set("v.loading", 'There was an issue with the query, please notify admin');
            }
        });
        $A.enqueueAction(action);
        
        var act = cmp.get("c.getSchedule");
        act.setParams({
            "lineid":cmp.get("v.lineid")
        });
        console.log(cmp.get("v.lineid"));
        act.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                cmp.set("v.lineitems", data.getReturnValue());
                console.log('sucess line items')
                //cmp.set("v.loading", null);    
                //helper.spinnerhide(cmp, event,helper);    
            }else{
                //helper.spinnerhide(cmp, event,helper); 
                cmp.set("v.loading", 'There was an issue with the query, please notify admin');
            }
        });
        $A.enqueueAction(act);
        console.log('line items');
        console.log(cmp.get("v.lineitems"));
    },
     toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinnerspa");
        $A.util.toggleClass(spinner, "slds-hide");
    }
   
})