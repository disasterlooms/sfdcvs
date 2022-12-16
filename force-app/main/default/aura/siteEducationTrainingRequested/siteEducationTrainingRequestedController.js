({
    myAction : function(cmp, event, helper) {
        helper.getallTrainings(cmp,event,helper);
    },
    orderCreated : function(cmp,event,helper){
        console.log('got it, there was an order created');
        helper.getallTrainings(cmp,event,helper);
    }, 
    newTraining : function(cmp,event,helper){
        console.log('new training action');
    }, 
    
    cancelUpdate : function(cmp,event,helper){
        console.log('delete');
        cmp.set("v.orderUp",[]);
        cmp.set("v.cancelBtn",[]);
        cmp.set("v.disabled",false);
        
        
    },
    trainUpdated : function(cmp,event,helper){
        console.log('updated');
        cmp.set("v.orderUp",[]);
        cmp.set("v.cancelBtn",[]);
        cmp.set("v.disabled",false);
        var severity = 'success'; //it could be 'confirm' or null
        var title = 'Training Request Submitted';
        var message = 'A rep will contact you shortly. You can see training information in Training Requested Tab';
        var messageContainer = cmp.find("messageContainer");
        messageContainer.displayMessage(severity,title,message);
        helper.getallTrainings(cmp,event,helper);
        
    },
    
    editTraining : function(cmp,event,helper){
       //console.log('edit existing training ');
       //cmp.set("v.orderUp",null);
       
       
       
       
       cmp.set("v.disabled",true);
       var tid = event.getSource().get("v.value");        
       var accId = event.getSource().get("v.name");
       
        
       console.log('tid '+tid);
        $A.createComponent(
            "lightning:button",
            {
                "aura:id": "findableAuraId",
                "label": "Cancel Update",
                "onclick": cmp.getReference("c.cancelUpdate")
            },
            function(cancBtn, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = cmp.get("v.cancelBtn");
                    body.push(cancBtn);
                    cmp.set("v.cancelBtn", body);
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
        
         $A.createComponent(
            "c:siteEducationProffesionalDevelopment",
            {
                "recordId": tid,
                "acctId" : accId
            },
            function(newOrder, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = cmp.get("v.orderUp");
                    body.push(newOrder);
                    cmp.set("v.orderUp", body);
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