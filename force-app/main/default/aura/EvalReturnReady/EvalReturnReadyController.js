({
    myAction : function(component, event, helper) {
        helper.showunits(component, event, helper);
    },
    EvalReturn : function(cmp, event, helper) {
        cmp.set("v.pselected" ,true);
        var units = cmp.find('btnret');
        $A.util.toggleClass(units, 'slds-hide');
    },
    completed : function(cmp,event,helper){
        console.log('complteed flow');
        $A.get("e.force:closeQuickAction").fire();
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The eval quote has been created and email will be sent out shortly.",
            "type" : "success"
        });
        toastEvent.fire();
        $A.get('e.force:refreshView').fire();
    }
})