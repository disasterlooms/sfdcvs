({
	onClick1 : function(cmp, event, helper) {
		let navItem = cmp.get("v.ButtonURL1");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": navItem
        });
        urlEvent.fire();
	},
    
    onClick2 : function(cmp, event, helper) {
		let navItem = cmp.get("v.ButtonURL2");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": navItem
        });
        urlEvent.fire();

	}
})