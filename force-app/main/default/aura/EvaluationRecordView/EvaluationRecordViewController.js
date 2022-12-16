({
    myAction : function(cmp, event, helper) {
    },
    save : function(cmp, event, helper) {
        helper.toggle(cmp,event,helper);
        cmp.find("edit").get("e.recordSave").fire();
        helper.toggle(cmp,event,helper);
        $A.get('e.force:refreshView').fire();
    }
})