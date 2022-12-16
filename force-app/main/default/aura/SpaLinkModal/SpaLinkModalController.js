({
	showOppmodal: function(component, event, helper) {
        //Toggle CSS styles for opening Modal
        helper.toggleClass(component,'backdrop','slds-backdrop--');
        helper.toggleClass(component,'modaldialog','slds-fade-in-');
        //var oppid = event.getParam("oppId");
        var oppid = component.get("v.oppid")
        console.log('oppid '+oppid);
        //component.set("v.oppid", oppid);        
        var spas = $A.get("e.c:displayspas");
        console.log('show spa link page oppid '+ component.get("v.oppid"));
        spas.setParams({ "oppId":  oppid});
        spas.fire();
        
	},
	hideModal : function(component, event, helper) {
		 //Toggle CSS styles for hiding Modal
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'modaldialog','slds-fade-in-');
	},
    spaupdate : function(cmp,event,helper){
        helper.toggle(cmp,event,helper);
        var spas = $A.get("e.c:updatespas");
        spas.fire();        
    },
    createSpa : function(cmp,event,helper){
        var spas = $A.get("e.c:createspas");
        spas.setParams({ "opportunity":  cmp.get("v.opportunity")
                       });
        console.log('send the opp object to event')
        spas.fire();        
    },
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinnerspa");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})