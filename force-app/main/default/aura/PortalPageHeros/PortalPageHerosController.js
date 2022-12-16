({
    myAction : function(cmp, event, helper) {
        console.log('cal to act');
        var showCall = cmp.get("v.showCallToAction");
        if(showCall){
            var header = cmp.get("v.ActionHeader");
            var label = cmp.get("v.ButtonLabel");
           /*
            var flow = cmp.find("flow");
            var inputVariables = [
                { name : "actionHeader", type : "String", value: header }, 
                { name : "buttonLabel", type : "String", value: label }
            ];
            */
            //flow.startFlow("portalPartnerCreateClaimModal", inputVariables);
            //
            
        }
        //cmp.set("v.isOpen",true);
        
    },
    callToAction : function(cmp,event,helper){
        var actionType = cmp.get("v.actionType");
        console.log('act type '+actionType);
        if(actionType == 'DealCreation'){
            helper.newDeal(cmp,event,helper);
        }else{
            
       
        
        var flowName = cmp.get("v.flow");
        var variables = cmp.get("v.flowVariables");
        console.log('launch');
        $A.createComponent(
                "sf_flowmodal:ccp_launchFlowModal",
                {
                    "flowName" : flowName,
                    "autoLaunchFlow" : true,
                    "hideButton" : true,
                    "flowInputVariablesString" : variables
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
        }
    }, 
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    
    
    parentFlowNextPage : function(cmp, event, helper) {
        console.log('next page on parent');
        var navigate = cmp.get('v.navigateFlow');
        navigate("NEXT");
    }
    
    
})