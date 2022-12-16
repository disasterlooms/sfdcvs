({
	
    myAction : function (cmp) {
        // Find the component whose aura:id is "flowData"
        var flow = cmp.find("flowData");
        // In that component, start your flow. Reference the flow's API Name.
        var lang = cmp.get("v.Language");
        console.log('language selelected '+lang);
        var inputVariables = [
         { name : "languageSelected", type : "String", value: lang }] 
         
        flow.startFlow("portalMySalesRep",inputVariables);
    },
})