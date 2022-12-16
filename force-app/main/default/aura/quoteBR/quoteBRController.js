({
	myAction : function(component, event, helper) {
		
	},
    handleSubmit : function(cmp,event,helper){
        cmp.set('v.showSpinner', true);
    },
    handleSuccess: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The discount has been updated successfully."
        });
        toastEvent.fire();
        
    },
    handleError: function(cmp, event, helper) {
        // errors are handled by lightning:inputField and lightning:nessages
        // so this just hides the spinnet
        cmp.set('v.showSpinner', false);
    },
    handleLoad: function(cmp, event, helper) {
        //no code yet.. exists as placeholder which is needed to avoid error
    },
})