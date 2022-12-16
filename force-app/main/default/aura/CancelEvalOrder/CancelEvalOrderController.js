({
    myAction : function(cmp, event, helper) {
            //$A.get("e.force:refreshView").fire();
            helper.showSpinner(cmp,event,helper);
            var geteval = cmp.get("c.getRelatedRecords");
            geteval.setParams({"recid" : cmp.get("v.recordId")});
            geteval.setCallback(this, function(data) {
                cmp.set("v.evalRequest", data.getReturnValue()[0]);

                helper.hideSpinner(cmp,event,helper);
                var locked = data.getReturnValue()[0].Locked_for_Approval__c;
                if(locked == true ){
                    helper.lockedRecord(cmp,event,helper); 
                }else{
                    helper.runFlow(cmp,event,helper);
                }
                console.log('the eval lock');
                console.log(data.getReturnValue()[0].Locked_for_Approval__c);


            });        
            $A.enqueueAction(geteval);
            console.log(' is locked ? ');
               
    },
    refresh : function(cmp,event,helper){
        cmp.find("evalcancel").reloadRecord();
        console.log('refreshing');        
    },
    handleStatusChange : function (cmp, event,helper) {
        console.log('run handlestatus chagne');
        console.log(event.getParam("status"));
        if(event.getParam("status") === "STARTED" || event.getParam("status") === "FINISHED") {            
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title": "Request Sent",
                "message": "Your cancelation request has been sent. If the shipping is pending, the order may not be able to be cancelled",
                "type" : "success",
                "key" : "approval"
            });
            resultsToast.fire(); 
            helper.closeaction(cmp,event,helper);
            console.log('close');
        }
    },
    close : function(cmp,event,helper){
        helper.closeaction(cmp,event,helper);
    }
})