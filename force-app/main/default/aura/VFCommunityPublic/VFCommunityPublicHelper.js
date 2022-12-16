({
	helperMethod : function() {
		
	},
    gettingCons : function(cmp,event,helper){
        console.log('getting cons');
        var acctid = cmp.get("v.recordId");
        var action = cmp.get("c.getContacts");
                action.setParams({
                    "accId": acctid
                });
                action.setCallback(this, function(data) {
                    var rslt = data.getState();
                    if (rslt === "SUCCESS"){
                        cmp.set("v.contacts", data.getReturnValue());
                        //cmp.set("v.loading", null);
                        console.log('cons '+data.getReturnValue());
                        //helper.spinnerhide(cmp, event,helper);    
                    }else{
                        //helper.spinnerhide(cmp, event,helper); 
                        cmp.set("v.loading", 'There was an issue with the query, please notify admin');
                    }
                });
                $A.enqueueAction(action);
        
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
        console.log('toast');
        var severity = 'success'; //it could be 'confirm' or null
        var title = 'User(s) Added';
        var message = 'You can now manage your account';
        var messageContainer = cmp.find("messageContainer");
        messageContainer.displayMessage(severity,title,message);
    },
    toasterrorAcct : function(cmp, event, helper) {
        console.log('toast');
        var severity = 'error'; //it could be 'confirm' or null
        var title = 'Account Not Found, Missing Valid Private Key';
        var message = 'No Customer Key found. Please contact your ViewSonic rep to send an updated link with a valid customer key.';
        var messageContainer = cmp.find("messageContainer");
        messageContainer.displayMessage(severity,title,message);
    }
})