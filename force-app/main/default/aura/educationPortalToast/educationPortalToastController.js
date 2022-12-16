({
	myAction : function(component, event, helper) {
		
	},
    
	closeModel : function(component, event, helper) {
		$A.util.addClass( component.find( 'toastModel' ), 'slds-hide' );
        component.set("v.messageType", "");
        component.set("v.messageType", "");
	}
})