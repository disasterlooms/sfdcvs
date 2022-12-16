({
   
	unlock : function(cmp, event, helper) {
		helper.getUnlockRecord(cmp);
	},
	 //spinner hide
    hideSpinner : function (component, event, helper) {
        component.set("v.Spinner", false);
    },
    //spinner show
    showSpinner : function (component, event, helper) {
        component.set("v.Spinner", true); 
    },
})