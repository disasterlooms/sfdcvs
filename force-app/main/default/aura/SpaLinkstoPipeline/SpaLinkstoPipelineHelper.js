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
    getSpas : function(cmp,event,helper){
        var action = cmp.get("c.getSpas");
        action.setParams({"oppid": cmp.get("v.recordId")
                          });
        action.setCallback(this, function(data) {
        cmp.set("v.spas", data.getReturnValue());
        });
        $A.enqueueAction(action);                 
    },
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinnerspa");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})