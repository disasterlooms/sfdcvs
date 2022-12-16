({
    myAction : function(component, event, helper) {
        component.find("packageCreator").getNewRecord(
            "Product_Package__c", 
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newPackage");
                var error = component.get("v.newPackageError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                }
                else {
                    console.log("Record template initialized: " + rec.sobjectType);
                }
            })
        );
    },
    handleSavePackage: function(component, event, helper) {
        helper.toggle(component,event,helper);
        component.find("packageCreator").saveRecord(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // record is saved successfully
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Package Created",
                    "message": "Now add products",
                    "type" : "success"
                });
                resultsToast.fire();
                var step = component.find("create");
                component.set("v.step1",false);
                helper.toggle(component,event,helper);
                component.set("v.pid", component.get("v.fnewPackage.Id"));
                console.log( component.get("v.fnewPackage.Id")+' the package id');
                
            } else if (saveResult.state === "INCOMPLETE") {
                // handle the incomplete state
                console.log("User is offline, device doesn't support drafts.");
                helper.toggle(component,event,helper);
            } else if (saveResult.state === "ERROR") {
                // handle the error state
                console.log('Problem saving contact, error: ' + 
                            JSON.stringify(saveResult.error));
                helper.toggle(component,event,helper);
            } else {
                console.log('Unknown problem, state: ' + saveResult.state +
                            ', error: ' + JSON.stringify(saveResult.error));
                helper.toggle(component,event,helper);
            }
        });
    }
    
})