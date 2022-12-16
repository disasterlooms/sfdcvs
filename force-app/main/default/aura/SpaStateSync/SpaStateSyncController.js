({
    myAction : function(cmp, event, helper) {
        var flow = cmp.find("flowexp");
        var inputVariables = [
            {
                name : "pbid",
                type : "String",
                value: cmp.get("v.simpleRecord.PriceBookId__c")
            },
            {
                name : "quoteid",
                type : "String",
                value : cmp.get("v.recordId")
            }
        ];
        console.log('oppid '+cmp.get("v.simpleRecord.PriceBookId__c"));    
        flow.startFlow("StateSpasSyncQuotes", inputVariables);
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
                "title": "Spa has been synced with state spa active products"
            });
            resultsToast.fire(); 
            $A.get('e.force:refreshView').fire();            
        }
    }
    
})