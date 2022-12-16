({
    myAction : function(cmp, event, helper) {
        
    },
    save : function(cmp, event, helper) {
        helper.toggle(cmp,event,helper);
        cmp.find("edit").get("e.recordSave").fire();
        var saveRecord = cmp.find("edit").get("e.recordSave");
        helper.toggle(cmp,event,helper);
        $A.get('e.force:refreshView').fire();        
    },
    handleSaveSuccess : function(cmp, event) {
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Saved",
            "message": "The record was saved."
        });
        resultsToast.fire();
    },
    approve : function(cmp,event,helper){
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Approval.ProcessSubmitRequest"
        });
        createRecordEvent.fire();
    }
 })