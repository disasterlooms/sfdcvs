({
	helperMethod : function() {
		
	},
    addspinner: function (cmp, event,helper) {
        $A.createComponent(
            "lightning:spinner",
            {
                "variant ": "brand",
                "size": "large",
                "alternativeText" : "spinner"
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
        var title = 'Training Request Submitted';
        var message = 'A rep will contact you shortly. You can see training information in Training Requested Tab';
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
     getOrders : function(cmp, event, helper) {
        helper.addspinner(cmp,event,helper);
        console.log('gettingtrainigs'); 
        var action = cmp.get("c.getTrainings");
        
        action.setParams({
            "acct": cmp.get("v.acct")
        });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                console.log(data.getReturnValue());
                var crtOrders = cmp.get("v.orders");
                if(crtOrders.length < data.getReturnValue().length){
                cmp.set("v.orders",data.getReturnValue());
                }
                console.log('success list of orders');
                helper.removespinner(cmp,event,helper);
            }else{
                
                console.log('error1 orders');
                var errors = data.getError();
                console.log(errors[0].message);
                //console.log(errors);
                cmp.set("v.errMessage",errors[0].message);
                helper.removespinner(cmp,event,helper);
                //helper.toastError(cmp,event,helper);
                //alert('Sorry, there was an error, please let admin know');
            }
        });
        $A.enqueueAction(action);
    },
    getallTrainings : function(cmp,event,helper){
        helper.addspinner(cmp,event,helper);
        console.log('gettingtrainigs'); 
        var action = cmp.get("c.getTrainings");
        
        action.setParams({
            "acctId": cmp.get("v.acct")
        });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                console.log(data.getReturnValue());
                var crtOrders = cmp.get("v.orders");
                if(crtOrders.length < data.getReturnValue().length){
                cmp.set("v.orders",data.getReturnValue());
                }
                console.log('success list of orders');
                helper.removespinner(cmp,event,helper);
            }else{
                
                console.log('error1 orders');
                var errors = data.getError();
                console.log(errors[0].message);
                //console.log(errors);
                cmp.set("v.errMessage",errors[0].message);
                helper.removespinner(cmp,event,helper);
                //helper.toastError(cmp,event,helper);
                //alert('Sorry, there was an error, please let admin know');
            }
        });
        $A.enqueueAction(action);
    }
    
})