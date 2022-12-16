({
    getUnlockRecord : function(cmp) {
        var recid = cmp.get("v.recordId");
        var action = cmp.get("c.getUnclockRecord");
        action.setParams({"currentRecord":recid});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Record Unlocked",
                    "message": "You are now free to edit.",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
                cmp.set("v.flag", false);
            }
        });
        $A.enqueueAction(action);
    }
})