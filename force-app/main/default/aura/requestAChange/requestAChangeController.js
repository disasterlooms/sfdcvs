({
    myAction : function(cmp, event, helper) {
        
    },
    handleLoad : function(cmp, event, helper) {
        
    },
    handleSubmit : function(cmp, event, helper) {
        
    },
    handleSuccess : function(cmp, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Thanks for the Feedback!",
            "message": "Your Request will be reviewed in the next 2 to 3 business days",
            "type" : "success"
        });
        toastEvent.fire();
        
    },
})