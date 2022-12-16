({
    statusChange : function(cmp, event, helper) {
        console.log('flow status change');
        var stage = event.getParam("currentStage");
        //cmp.set("v.currentStage",stage);
        //console.log(' Stage name '+stage.label);
        if(stage.label == 'Register'){
            console.log('modal ');
            var outputVariables = event.getParam("outputVariables");
            var outputVar;
            for(var i = 0; i < outputVariables.length; i++) {
                outputVar = outputVariables[i];
                // Pass the values to the component's attributes
                if(outputVar.name === "emailAddress") {
                    cmp.set("v.email", outputVar.value);
                } 
            }
            console.log(' email '+cmp.get("v.email"));
            helper.registration(cmp,event,helper);
        }
        
    },
    
    
    
    runFlow : function(cmp,event,helper){
        console.log('moadl flow ');
        var flow = cmp.find("flowData");
        flow.startFlow("portalPasswordReset");
    }
})