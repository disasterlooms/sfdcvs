({
	myAction : function(cmp, event, helper) {
		 var flow = cmp.find("flowData");
        // In that component, start your flow. Reference the flow's API Name.
        flow.startFlow("pp_addressUpdate");
	},
    statusChange : function (cmp, event,helper) {
        console.log('control flow finish/next');
        if(event.getParam("status") === "FINISHED") {
           var navigate = cmp.get('v.navigateFlow');
        navigate('FINISH'); 
        }
        
    }
})