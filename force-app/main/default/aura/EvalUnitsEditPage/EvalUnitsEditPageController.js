({
	handleSubmit : function(component, event, helper) {
        component.find("editForm").submit();
		
	},
    handleSuccess : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Updated",
            "message": "Successfully Updated Record",
            "type" : "success",
            "key" : "approval"
        });
        resultsToast.fire();
       
        
    },
    handleLoad : function(component, event, helper) {
		
	}
})