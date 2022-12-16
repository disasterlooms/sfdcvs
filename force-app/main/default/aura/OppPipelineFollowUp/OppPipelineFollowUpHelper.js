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
    getOppContacts : function(cmp,event,helper){
        console.log('opportunities');
        console.log(cmp.get("v.opportunities"));
        var action = cmp.get("c.getOppContacts");
        action.setParams({"opps": cmp.get("v.opportunities")
                          });
        action.setCallback(this, function(data) {
        cmp.set("v.oppcontacts", data.getReturnValue());
        });
        $A.enqueueAction(action);                 
    },
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinnerflu");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})