({
    /*	invokeflow : function(component, event, helper) { 
        
      ///This section is through navigate to component 
        //var quoteid = event.getSource().get("v.value");
        var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
            componentDef: "c:UpdateSPAtoBidRegisteredcmp",
            componentAttributes: {
                    recordId :component.get("v.recordId")
                }
        });
        evt.fire();
        
        
	},*/
     saveReason: function(cmp, event, helper) {
		helper.updateQoute(cmp);
	},
    close: function(cmp, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	},   
    
     hideSpinner : function (component, event, helper) {
        component.set("v.Spinner", false);
    },
    //spinner show
    showSpinner : function (component, event, helper) {
        component.set("v.Spinner", true); 
    },
})