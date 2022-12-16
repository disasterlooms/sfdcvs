({
	helperMethod : function() {
		
	},    
    hideSpinner : function (cmp, event,helper) {
        console.log('hide spinner');
        var spinner = cmp.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    showSpinner : function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    }
})