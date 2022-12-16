({
    getTicketDetails : function(cmp,event,helper) {
        //var ticket_id = cmp.get("v.fdTicketId");
        console.log('Ticket Id to comp '+cmp.get("v.fdTicketId"));
        var action = cmp.get("c.getTicketData");        
        action.setParams({
            "ticketId" : cmp.get("v.fdTicketId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                // set the response(return Map<String,object>) to response attribute.      
                var dta = response.getReturnValue();
                console.log('the json returned ');
                console.log(dta);
                var parsed = '';
                try{
                    parsed = JSON.parse(dta);
                }catch(e){
                   // parsed = 'Something went wrong. SFDC team notified and will reach out shortly.';
                }                
                //cmp.set("v.converstations",dta);
                cmp.set("v.conversations", parsed);
                console.log(parsed);
                cmp.set("v.disabled",false);
                helper.hidespinner(cmp,event,helper);
            }else{              
                let errors = response.getError();
                let message = 'Unknown error, please notify admin'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                var spinner = cmp.find("mySpinner");
                helper.hidespinner(cmp,event,helper);
                alert(message);
                cmp.set("v.disabled",false);
                
            }
        });
 
        $A.enqueueAction(action);
        //

    },
    showSpinner : function (cmp, event,helper) {
        $A.createComponent(
            "lightning:spinner",
            {
                "aura:id": "mySpinner",
                "variant":"brand",
                 "size": "large"
            },
            function(newSpinner, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(newSpinner);
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
    hidespinner : function (cmp, event,helper) {
        var body = cmp.set("v.body",[]);
    }
})