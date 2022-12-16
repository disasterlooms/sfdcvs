({
    helperMethod : function() {
        
    },
    registration : function(cmp, event, helper) {
        //var flowName = cmp.get("v.flow");
        var email = cmp.get("v.email");
        var emailfirst = email.substring(0, email.indexOf("@"));
        console.log('first '+emailfirst);
        var inputVariables = '[   {     "name" : "emailReset", "type" : "String", "value": "'+email+'"    } ]';
        
       // var obj = JSON.parse('{"firstName":"John", "lastName":"Doe"}');
        //,"flowInputVariablesString": variables
        console.log(inputVariables);
         console.log('variables');
        console.log('launch registration modal');
        $A.createComponent(
            "sf_flowmodal:ccp_launchFlowModal",
            {
                "flowName" : 'publicPartnerCommunityRegistration',
                "autoLaunchFlow" : true,
                "hideButton" : true,
                "flowInputVariablesString" : inputVariables
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
        
    },
})