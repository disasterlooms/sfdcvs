({
    updateQoute : function(component) {
        debugger;
        var currentRecord =component.get("v.recordId");
        var WorkActivity = component.get("v.WorkActivity");
        var ScopeOfBidRegistration = component.get("v.ScopeOfBidRegistration");
        var BusinessReasonforBidRegistration = component.get("v.BusinessReasonforBidRegistration");
        
        var action = component.get("c.getUpdatedRecord");
        action.setParams({"currentRecord":currentRecord,
                          "WorkActivity":WorkActivity,
                          "ScopeOfBidRegistration":ScopeOfBidRegistration,
                          "BusinessReasonforBidRegistration":BusinessReasonforBidRegistration});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                var storeResponse = response.getReturnValue();
                //if(storeResponse.SUCCESS){
                    var toastEvent = $A.get("e.force:showToast");               
                    toastEvent.setParams({
                        "type":"Success",
                        "title": "Success!",
                        "duration":"5000",
                        "message": "Quote updated Successfully"
                    });
                    toastEvent.fire();
                    
                   
                       var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": "lightning/r/Opportunity/"+storeResponse+"/view"
                        });
                        urlEvent.fire();
                }else{
                    var errmsg = response.getError();
                    var messages = '';
                    for(var i = 0; i < errmsg.length; i++){
                        messages = messages + '\n\n'+errmsg[i].message;
                    }
                    var toastEvent = $A.get("e.force:showToast");               
                    toastEvent.setParams({
                        "type":"Error",
                        "title": "Error!",
                        "message": messages
                    });
                    toastEvent.fire();
                        
                        //storeResponse.MESSAGE
                    
                //}
                // set current user information on userInfo attribute
                //component.set("v.UserInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
        
    }
})