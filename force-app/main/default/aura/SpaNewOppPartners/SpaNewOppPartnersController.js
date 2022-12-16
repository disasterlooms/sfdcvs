({
	myAction : function(cmp, event, helper) {
		//cmp.find("quote").set("v.value", cmp.get("v.recordId"));
        var createRecordEvent = $A.get("e.force:createRecord");
        console.log('quote '+cmp.get("{!v.recordId}"));
        createRecordEvent.setParams({
            "entityApiName": "Opportunity_Partner__c",
            "defaultFieldValues": {
                'Quote__c' : cmp.get("{!v.recordId}"),
                'Opportunity__c' : cmp.get("{!v.simpleRecord.OpportunityId__c}")
            }
        });
        createRecordEvent.fire();
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        
    }
})