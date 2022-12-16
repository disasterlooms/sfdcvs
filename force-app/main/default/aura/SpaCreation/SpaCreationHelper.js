({
	helperMethod : function() {
		
	},
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinnerspa");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})