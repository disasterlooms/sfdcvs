({
	myAction : function(component, event, helper) {
		
	},
    handleSubmit : function(cmp, event, helper) {
		cmp.set("v.disabled",true);
	},
    handleSuccess : function(cmp, event, helper) {
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Notes Submitted",
            "message": "Request was sent to bid desk",
            "type" : "success",
            "key" : "approval"
        });
        resultsToast.fire();
        
        var navEvt = $A.get("e.force:navigateToSObject");
        console.log(cmp.get("v.recordId"));
        
        navEvt.setParams({
            "recordId": cmp.get("v.recordId")
        });
        navEvt.fire();
        
		
	},
    handleLoad : function(component, event, helper) {
		
	},
})