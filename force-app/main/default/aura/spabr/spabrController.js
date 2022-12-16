({
    
	invokeflow : function(component, event, helper) { 
        
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
        
        
	},
    editBR : function(cmp,event,helper){
        var spas = $A.get("e.force:editRecord ");
        var oppid = cmp.get("v.opportunity.Id");
        var spaid = cmp.get("v.opportunity.SPA_ID__c")
        spas.setParams({
            "recordId": cmp.get("v.recordId"),
            "defaultFieldValues": {
                'RecordTypeId' : '0121H000001QBRJ'
            }
        });
        console.log('oppid '+cmp.get("v.opportunity.Id"));
        spas.fire();      
    },
     doInit: function(cmp, event, helper) {
		helper.getAccessDetails(cmp);
	},
})