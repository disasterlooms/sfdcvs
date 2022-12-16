({
    myAction: function(cmp,event,helper){
        
    },
    callToAction : function(cmp, event, helper) {
        console.log('launch flow');
        $A.createComponent(
            "sf_flowmodal:ccp_launchFlowModal",
            {
                "flowName" : "publicPartnerCommunityRegistration",
                "autoLaunchFlow" : true,
                "hideButton" : true
            },
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
    }
})