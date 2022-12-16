({
	helperMethod : function(cmp,event,helper) {
		
        var action = cmp.get("c.editTraining");
        console.log('loading order rec id '+ cmp.get("v.recordId"));  
   		console.log('acct id '+cmp.get("v.acctId"));        
        action.setParams({
            "orderId": cmp.get("v.recordId"),
            "acctId" : cmp.get("v.acctId")
        });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                console.log(data.getReturnValue());
                var o = data.getReturnValue();
                if(o.length > 0){
                    if(o[0].Status != 'Completed'){
                        cmp.set("v.order",o[0]);
                    }                   
                    
                }else{
                    cmp.set("v.order.AccountId", cmp.get("v.acctId"));
                    console.log(cmp.get("v.order.AccountId")+ ' acct id');
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
        var title = 'Training Request Submitted';
        var message = 'A rep will contact you shortly. You can see training information in Training Requested Tab';
        var messageContainer = cmp.find("messageContainer");
        messageContainer.displayMessage(severity,title,message);
        helper.helperMethod(cmp,event,helper);
        helper.addspinner(cmp,event,helper);
    },
     toastError : function(cmp, event, helper) {
        console.log('con user page toast')
        var severity = 'error'; //it could be 'confirm' or null
        var title = 'Sorry There Was an error';
        var message = cmp.get("v.errMessage");
        var messageContainer = cmp.find("messageContainer");
        messageContainer.displayMessage(severity,title,message);
    },
    addDays : function (date, days) {
        var result = new Date(date);
        result.setDate(result.getDate() + days);
        return result;
    },
})