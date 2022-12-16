({ 
    init: function(cmp,event,helper){
        helper.accessCheck(cmp, event, helper);
    }, 
    updateProducts : function (cmp,event,helper) {
        helper.showSpinner(cmp,event,helper);
        var action = cmp.get("c.updateSelected");
        action.setParams({"units": cmp.get("v.records")
                         });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Product Status Updated!",
                    "message": "The records have been updated successfully.",
                    "type" : "success"
                });
                toastEvent.fire();
                helper.hideSpinner(cmp,event,helper);
                var unitRecords = data.getReturnValue();
                console.log(data.getReturnValue());    
            }else{
                helper.hideSpinner(cmp,event,helper);
                alert(rslt.getError()); 
            }
        });
        $A.enqueueAction(action);

    },



    
    returnflow : function(cmp,event,helper){
        //debugger;
        console.log('return event');
        helper.flow(cmp,event,helper);
    },
    flowComplete : function(cmp,event,helper){
        //debugger;
        var status = event.getParam("status");
        console.log('this has changed');
        console.log(status);
        if( status === "FINISHED") {
            cmp.set("v.completed" , true);
            
        }
        
        
    },
    flowPrev : function(cmp,event,helper){
        var navigate = cmp.get('v.navigateFlow');
        navigate("BACK");
    }
})