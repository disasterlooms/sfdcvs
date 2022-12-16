({
    myAction : function(cmp, event, helper) {
        var flow = cmp.find("flowexp");
        var inputVariables = [
            {
                name : "oppid",
                type : "String",
                value: cmp.get("v.simpleRecord.OpportunityId__c")
            }
        ];
        console.log('oppid '+cmp.get("v.simpleRecord.OpportunityId__c"));    
        flow.startFlow("QuoteCreatedDistyUpdate", inputVariables);
    },
    flowComplete : function(cmp,event,helper){
        var status = event.getParam("status");
        console.log('this has changed');
        console.log(status);
        if( status === "FINISHED" || status === 'FINISHED_SCREEN') {
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            $A.get('e.force:refreshView').fire();
			var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title": "Parnters has been updated"
            });
            resultsToast.fire(); 
            $A.get('e.force:refreshView').fire();            
        }
    }
    
})