({
	displayMessage : function(component, event, helper) {
		var params = event.getParam('arguments');
		if(!params){
			return;
		}
		var severity = params.severity;
		var title = params.title;
		var message = params.message;
        var mode  = params.mode;

		var toastClass = (severity === 'confirm') 	? 'slds-notify slds-notify--toast slds-theme--success' :
						 (severity === 'error') 	? 'slds-notify slds-notify--toast slds-theme--error' :
                         (severity === 'success') 	? 'slds-notify slds-notify--toast slds-theme--success' :
						 'slds-notify slds-notify--toast'; 

		component.set("v.severity",severity);
		component.set("v.title",title);
		component.set("v.message",message);
		component.set("v.toastClass",toastClass);
		helper.showMessage(component,event);
        var overRide = component.get("v.timeOverride");
        console.log('over ride '+overRide);

		setTimeout(function(){ 
			helper.hideMessage(component,event);
            
		}, overRide);
	},
	hideMessage : function(component,event,helper){
		helper.hideMessage(component,event);
	}


})