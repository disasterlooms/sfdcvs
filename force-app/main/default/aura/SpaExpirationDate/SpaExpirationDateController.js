({
    myAction : function(cmp, event, helper) {
        var flow = cmp.find("flowexp");
        var inputVariables = [
            {
                name : "quoteid",
                type : "String",
                value: cmp.get("v.recordId")
            }
        ];
        console.log('no quote id');    
        flow.startFlow("SpaproductsExpirationDate", inputVariables);
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
                "title": "Expiration Date Products Updated"
            });
            resultsToast.fire(); 
            $A.get('e.force:refreshView').fire();            
        }
    }
    
})