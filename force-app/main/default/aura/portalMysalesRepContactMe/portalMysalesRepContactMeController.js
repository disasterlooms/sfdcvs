({
    myAction : function(cmp, event, helper) {
        
    },
    handleClick  : function(cmp,event,helper){
        
        
        /*
        
        var con = cmp.get("v.conId");
        var acct = cmp.get("v.acctId");
        var rep = cmp.get("v.repId");
        console.log('clicked btn');
        console.log(rep);
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Customer_Contact_Request__c",
            "defaultFieldValues": {
                'Account__c' : acct,
                'Contact__c' : con,
                'Sales_Rep__c' : rep,
                'Name' : 'Customer Requests Contact from Portal'
            }
        });
        createRecordEvent.fire();
        */
    },
    callToAction : function(cmp,event,helper){
        
        
        
        var flowName = cmp.get("v.flow");
        var variables = cmp.get("v.flowVariables");
        console.log('launch con form');
        $A.createComponent(
            "sf_flowmodal:ccp_launchFlowModal",
            {
                "flowName" : 'portalContactRequestForm' ,
                "autoLaunchFlow" : true,
                "hideButton" : true,
                "flowInputVariablesString" : variables
            },
            function(newButton, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    console.log(' success')
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
    }
})