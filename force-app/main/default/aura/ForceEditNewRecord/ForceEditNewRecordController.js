({
	myAction : function(component, event, helper) {
		helper.spinner(component, event, helper);
        var objname = component.find("objname");
        component.find("creator").getNewRecord(
            objname, // sObject type (entityAPIName) 
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newRecord");
                var error = component.get("v.newRecordError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                }
                else {
                    console.log("Record template initialized: " + rec.sobjectType);
                }
            })
        );
	}
})