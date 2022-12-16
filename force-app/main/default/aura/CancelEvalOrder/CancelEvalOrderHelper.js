({
	helperMethod : function() {
		
	},
    closeaction : function(cmp,event,helper){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire(); 
    },
    showSpinner: function (cmp, event,handler) {
        var spinner = cmp.set("v.toggleClass","");
    },
    hideSpinner: function (cmp, event,handler) {
        var spinner = cmp.set("v.toggleClass","slds-hide");
    },
    runFlow : function (cmp, event,handler) {
        var flow = cmp.find("flowcancel");
            console.log(flow);
            var inputVariables = [
                {
                    name : "evalid",
                    type : "String",
                    value: cmp.get("v.recordId")
                }
            ];
            flow.startFlow("Eval_Order_Cancellation_Request" , inputVariables); 

    },
    lockedRecord : function (cmp, event,handler) {
        var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                "title": "Error!",
                "message": "This record is in an approval process and is locked. Before you can edit or cancel, you must recall the approval request.",
                "mode": "pester",
                "type": "error"
                });
                toastEvent.fire();

    }
       
})