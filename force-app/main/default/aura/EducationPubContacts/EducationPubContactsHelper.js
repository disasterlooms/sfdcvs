({
	helperMethod : function() {
		
	},
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinnerspa");
        $A.util.toggleClass(spinner, "slds-hide");
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
        console.log('con user page toast')
        var severity = 'success'; //it could be 'confirm' or null
        var title = 'Contact Updated';
        var message = 'Contact(s) are updated';
        var messageContainer = cmp.find("messageContainer");
        messageContainer.displayMessage(severity,title,message);
    },
    getCons : function(cmp,event,handler){
        console.log('getting cons on acctid change');
        var acctid = cmp.get("v.accid");
        console.log('acct id changed here is id to get contacts '+acctid);
        var action = cmp.get("c.getContacts ");
        action.setParams({
            "accId": acctid
        });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                cmp.set("v.cons", data.getReturnValue());
                
                console.log('get contacst first name');                           
                //cmp.set("v.loading", null);
                console.log(data.getReturnValue());
                //helper.spinnerhide(cmp, event,helper);    
            }else{
                //helper.spinnerhide(cmp, event,helper); 
                cmp.set("v.loading", 'There was an issue with the query, please notify admin');
            }
        });
        $A.enqueueAction(action);
        
    },
})