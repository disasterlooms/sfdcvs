({
	myAction : function(cmp, event, helper) {
        var opp = cmp.find("oppid");
        var name = cmp.find("spaname");
        console.log(opp);
        opp.get("v.readonly");
        console.log('read only');
        //name.set("v.readonly",true);
    },
    submitted : function(cmp, event, helper) {
    helper.toggle(cmp,event,helper);
    },
    saved : function(cmp, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "The Spa has been saved.",
            "message": "The bid desk now has this spa request. Thank You.",
            "type" : "success"
        });
        toastEvent.fire();
        helper.toggle(cmp,event,helper);
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        $A.get('e.force:refreshView').fire();
    },
    setFields :  function(cmp, event, helper) {
      //var name = cmp.find("spaname");
      //name.set("v.value"), cmp.get("v.simpleRecord.SPA_ID__c"))
    }
})