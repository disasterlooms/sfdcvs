({
    
    updateQoute : function(component) {
        debugger;
        var currentRecord =component.get("v.recordId");
        var reason = component.get("v.reason");
        var action = component.get("c.getUpdatedQuote");
        action.setParams({"reason":reason,"currentRecord":currentRecord});
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
                    "message": "Quote submitted for Auto Renewal Successfully"
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
                
            }else{
                var errmsg = response.getError();
                var messages = '';
                for(var i = 0; i < errmsg.length; i++){
                    messages = messages + '\n\n'+errmsg[i].message;
                }
                var toastEvent = $A.get("e.force:showToast");               
                toastEvent.setParams({
                    "duration":10000,
                    "type":"Error",
                    "title": "Error!",
                    "message": messages
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
                
            }
        });
        $A.enqueueAction(action);
        
    }
})