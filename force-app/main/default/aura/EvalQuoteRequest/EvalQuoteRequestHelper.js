({
	helperMethod : function() {
		
	},
    spinnerRemove: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinnerEval");
        $A.util.addClass(spinner, 'slds-hide');
    },
})