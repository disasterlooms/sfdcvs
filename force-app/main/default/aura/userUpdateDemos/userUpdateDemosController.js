({
	myAction : function(cmp, event, helper) {
		
	},
    handleLoad : function(cmp, event, helper) {
        cmp.set("v.showhide", "slds-hide");
		
	},
    handleSubmit : function(cmp, event, helper) {
		
	},
    handleSuccess : function(cmp, event, helper) {
        console.log('success');
        var navigate = cmp.get('v.navigateFlow');        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Demographis have been updated successfully.",
            "type" : "success"
        });
        toastEvent.fire();
        navigate("FINISH");

		
	},
})