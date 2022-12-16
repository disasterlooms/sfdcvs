({
	showOppmodal: function(component, event, helper) {
		//Toggle CSS styles for opening Modal
		console.log('component for the spa link');
        helper.toggleClass(component,'backdrop','slds-backdrop--');
		helper.toggleClass(component,'modaldialog','slds-fade-in-');
        //var opps = event.getParam("opportunities");
        //component.set("v.opportunities", opps);
        //console.log(opps);
       //helper.getOppContacts(component,event,helper);
	},
	hideModal : function(component, event, helper) {
		 //Toggle CSS styles for hiding Modal
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'modaldialog','slds-fade-in-');
	},
    test : function(cmp,event,helper){
        console.log('running spas');d
    }
})