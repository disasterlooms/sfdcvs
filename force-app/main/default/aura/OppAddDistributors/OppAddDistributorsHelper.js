({
	helperMethod : function() {
		
	},
    toggleClass: function(cmp,componentId,className) {
        var modal = cmp.find(componentId);
        $A.util.removeClass(modal,className+'hide');
        $A.util.addClass(modal,className+'open');
    },
    toggleClassInverse: function(cmp,componentId,className) {
        var modal = cmp.find(componentId); 
        $A.util.addClass(modal,className+'hide');  
        $A.util.removeClass(modal,className+'open');
    },
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})