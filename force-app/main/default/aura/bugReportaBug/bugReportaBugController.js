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
            "message": "Your Bug Request will be reviewed within 1 business day. If urgent, please Zoom a message to Salesforce Admin",
            "type" : "success"
        });
        toastEvent.fire();
        
    },
})