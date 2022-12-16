({
	unlock : function(cmp, event, helper) {
        var spinner = cmp.find("mySpinnerpart");
        $A.util.toggleClass(spinner, "slds-hide");
        var action = cmp.get("c.unlockrec");
        var recid = cmp.get("v.recordId");
        action.setParams({
            "oppid" : recid
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                var spinner = cmp.find("mySpinnerpart");
                $A.util.toggleClass(spinner, "slds-hide");
                $A.get('e.force:refreshView').fire();
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Record Unlocked",
                    "message": "You are now free to edit towards mayhem!",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
            }
            else{
                alert(resp.getError());
                var spinner = cmp.find("mySpinnerpart");
                $A.util.toggleClass(spinner, "slds-hide");
            }
        });
        $A.enqueueAction(action);
        console.log(recid)
	},
    myAction : function(cmp, event, helper) {
    }
})