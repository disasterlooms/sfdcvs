({
	helperMethod : function() {
		
	},
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide"); 
    }
})