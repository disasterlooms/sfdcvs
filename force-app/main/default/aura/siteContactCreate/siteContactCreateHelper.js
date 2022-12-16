({
	helperMethod : function() {
		
	},
    addspinner: function (cmp, event,helper) {
        $A.createComponent(
            "lightning:spinner",
            {
                "variant ": "brand",
                "size": "large"
            },
            function(newButton, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = cmp.get("v.modal");
                    body.push(newButton);
                    cmp.set("v.modal", body);
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
    toast : function(cmp, event, helper) {
        console.log('toast');
        var severity = 'success'; //it could be 'confirm' or null
        var title = 'User Added';
        var message = 'You may need to refresh to see user';
        var messageContainer = cmp.find("messageContainer");
        messageContainer.displayMessage(severity,title,message);
    },
    removespinner : function (cmp, event,helper) {
        cmp.set("v.modal",'');
        
    },
})