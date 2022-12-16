({
	toggleClass: function(component,componentId,className) {
		var modal = component.find(componentId);
		$A.util.removeClass(modal,className+'hide');
		$A.util.addClass(modal,className+'open');
	},

	toggleClassInverse: function(component,componentId,className) {
		var modal = component.find(componentId); 
		$A.util.addClass(modal,className+'hide');  
		$A.util.removeClass(modal,className+'open');
	},
    getoppid : function(cmp,event){
        var status = event.getParam("status");
        console.log('status '+status);
        cmp.set("v.status", status);
        var self = this;
        var oppId = event.getParam("oppId");
        cmp.set("v.newoppid", oppId);
        console.log('the opp id from the button');
        console.log(oppId);
        var action = cmp.get("c.getPricebook");
        action.setParams({
                'oppid' : oppId
            });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.pricebook", response.getReturnValue());
                console.log('pricebook '+response.getReturnValue());
                console.log(response.getReturnValue());
            }
         });
         $A.enqueueAction(action); 
    }
})