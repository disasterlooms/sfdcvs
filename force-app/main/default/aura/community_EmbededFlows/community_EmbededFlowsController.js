({
    myAction : function(cmp, event, helper) {
        console.log('starting communtiy embed Flow');        
        var name = cmp.get("v.flowName");
        console.log('api name flow '+name);
        var flow = cmp.find("flowData");
        console.log('cmp find '+flow);
        flow.startFlow(name);
        
        
    }
})