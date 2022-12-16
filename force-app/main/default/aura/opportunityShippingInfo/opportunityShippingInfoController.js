({
	myAction : function(cmp, event, helper) {
		
	},
    handleLoad : function(cmp, event, helper) {
		cmp.set("v.showSpinner",false);
	},
    handleSubmit : function(cmp, event, helper) {
		cmp.set("v.showSpinner",true);
        cmp.set("v.disabled",true);
	},
    handleSuccess : function(cmp, event, helper) {
		cmp.set("v.showSpinner",false);
        cmp.set("v.disabled",false);
	},
    handleError : function(cmp, event, helper) {
		
	},
    
    
})