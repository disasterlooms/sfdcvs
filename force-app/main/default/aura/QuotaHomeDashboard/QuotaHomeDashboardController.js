({
    myAction : function(cmp, event, helper) {
        var reps = cmp.get("c.getUser");        
        reps.setCallback(this, function(data) {
            cmp.set("v.user", data.getReturnValue());
            console.log(cmp.get("v.user"));
            console.log('user info dashboard');
            $A.createComponent(
                
                "wave:waveDashboard",
                {
                    "dashboardId": data.getReturnValue().Quota_Dashboard__c,
                    "height": "1000",
                    "showHeader": false
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
            console.log('builidng comp');
        })
        $A.enqueueAction(reps);
    }
})