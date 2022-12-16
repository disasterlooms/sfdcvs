({
	helperMethod : function() {
		
	},
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide"); 
    },
    hide: function(cmp,componentId,className) {
		cmp.set("v.open", false);
	},

	show: function(cmp,componentId,className) {
		cmp.set("v.open", true);
	},
})