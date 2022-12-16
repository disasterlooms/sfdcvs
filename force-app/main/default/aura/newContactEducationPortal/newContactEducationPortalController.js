({
    myAction : function(component, event, helper) {
        var createAcountContactEvent = $A.get("e.force:createRecord");
        createAcountContactEvent.setParams({
            "entityApiName": "Contact"
        });
        createAcountContactEvent.fire();
        
    }
})