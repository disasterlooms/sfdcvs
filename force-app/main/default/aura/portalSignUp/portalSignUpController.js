({
	myAction : function(component, event, helper) {
		
	},
    callToAction : function(cmp, event, helper) {
        console.log('sign up event');
		console.log('launch flow');
        var lang = cmp.get("v.languageDefault_Iso");
        console.log('lang '+lang);
        var inputVars = '[ { "name" : "languageDefault_iso", "type" : "String", "value": "'+lang+'" }]';
       
        $A.createComponent(
                "sf_flowmodal:ccp_launchFlowModal",
                {
                    "flowName" : "publicPartnerCommunityRegistration",
                    "autoLaunchFlow" : true,
                    "hideButton" : true,
                    "flowInputVariablesString" : inputVars,                
                } ,
                function(newButton, status, errorMessage){
                    //Add the new button to the body array
                    if (status === "SUCCESS") {
                        var body = cmp.get("v.body");
                        body.push(newButton);
                        cmp.set("v.body", body);
                    }
                    else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                        // Show offline error
                    }
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                            // Show error message
                        }
                }
            );
	},
})