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
    removespinner : function (cmp, event,helper) {
        cmp.set("v.body",'');
        
    },
    toast : function(cmp, event, helper) {
        console.log('Case toast')
        var severity = 'success'; //it could be 'confirm' or null
        var title = 'A Service Case has been opened';
        var message = 'A rep will contact you shortly.';
        var messageContainer = cmp.find("messageContainer");
        messageContainer.displayMessage(severity,title,message);
    },
     toastError : function(cmp, event, helper) {
        console.log('con user page toast')
        var severity = 'error'; //it could be 'confirm' or null
        var title = 'Sorry There Was an error';
        var message = cmp.get("v.errMessage");
        var messageContainer = cmp.find("messageContainer");
        messageContainer.displayMessage(severity,title,message);
    },
})