({
	myAction : function(component, event, helper) {
		
	},
    flow : function(cmp,event,helper){
        var flow = cmp.find("flowquote");
        var flowdiv = cmp.find('flow');
        var flowname = "ProductBundle_Clone_Lightning"
        console.log(flow);
        var recid = cmp.get("v.recordId");
           var inputVariables = [
            {
                name : "packageid",
                type : "String",
                value: recid
            }
        ];
                    
     flow.startFlow( flowname, inputVariables);
    },
    flowComplete : function(cmp,event,helper){
        var status = event.getParam("status");
        console.log('this has changed');
        console.log(status);
        var outputVar = '';
        if( status === "FINISHED") {
            var outputVariables = event.getParam("outputVariables");
            for(var i = 0; i < outputVariables.length; i++) {
                outputVar = outputVariables[i];
                if(outputVar.name === "newpackageid") {
                   var newpackid = outputVar.value;
                    cmp.set("v.newpackid", outputVar.value);
                }
            }
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
       		dismissActionPanel.fire();
            var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Clone Created",
            "message": "The clone was created!",
            "type" : "success"
        });
        resultsToast.fire();
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": newpackid
        });
        navEvt.fire();
                
                
            }
    }
})