({
    doInit : function(cmp, event, helper) {
        // Get a reference to the getWeather() function defined in the Apex controller
		var action = cmp.get("c.getEval");
        action.setParams({
            "recid": cmp.get("v.recordId")
        });
        console.log('rec id '+cmp.get("v.recordId"));
        // Register the callback function
        action.setCallback(this, function(data) {         
        console.log(data.getReturnValue());
            cmp.set("v.eval", data.getReturnValue());            
        });
        // Invoke the service
        $A.enqueueAction(action);
    }
    
})