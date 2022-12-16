({
    checkUser : function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log('non admin user');
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId"),
                "slideDevName": "detail"
            });
            navEvt.fire();        
    }
})