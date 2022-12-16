({
	myAction : function(component, event, helper) {
		
	},
    saved : function(cmp,event,helper){
        console.log('saved');
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        helper.toggle(cmp,event,helper);
        dismissActionPanel.fire();
        //$A.get('e.force:refreshView').fire();
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": cmp.get("v.recordId")
        });
        navEvt.fire();
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The spa has been updated.",
            "type" : "success"
        });
        toastEvent.fire();
        
    },
    submitted : function(cmp,event,helper){
        helper.toggle(cmp,event,helper);
        console.log('subbed');
    },
    errormsg : function(cmp,event,helper){
        helper.toggle(cmp,event,helper);
        console.log('subbed');
    }
})