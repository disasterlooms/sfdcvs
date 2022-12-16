({
	myAction : function(component, event, helper) {
		
	},
    showOppmodal: function(component, event, helper) {
        console.log('show modal');
        
        var oppid = event.getParam("oppid");
        component.set("v.oppid" , oppid);
        //console.log('oppid '+oppid);
        //component.find("record").reloadRecord();
        helper.toggleClass(component,'backdrop','slds-backdrop--');
        helper.toggleClass(component,'modaldialog','slds-fade-in-');
        
        
	},
    hideModal : function(component, event, helper) {
		 //Toggle CSS styles for hiding Modal
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'modaldialog','slds-fade-in-');
	}
})