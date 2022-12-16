({
    myAction : function(cmp, event, helper) {
        $A.get("e.force:refreshView").fire();
        var acct = cmp.get("c.getbillAcct"); 
        acct.setParams({"evalid" : cmp.get("v.recordId")
                       });     
        acct.setCallback(this, function(data) {
            cmp.set("v.account", data.getReturnValue());
            var state = data.getState();
            if (state === "SUCCESS") {
                console.log('sucess'); 
                //var acctid = cmp.get("v.account.Id");
                //console.log(cmp.get("v.account.Id"));
                //cmp.set("v.acctId", '0011200001JsdGSAAZ');
                //console.log('acctid '+cmp.get("v.acctId"));
                cmp.find("evalbill").reloadRecord();
            }
        });        
        $A.enqueueAction(acct);
        console.log(cmp.get("v.account"));
        
        
    },
    cancel : function(cmp,event,helper){
        var cls = $A.get("e.force:closeQuickAction");
        cls.fire();
        
    },
    save: function(cmp, event, helper) {
        //component.set("v.simpleRecord.AccountId", component.get("v.recordId"));
        helper.toggle(cmp,event,helper);
        cmp.find("evalbill").saveRecord(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // record is saved successfully
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Saved",
                    "message": "The record was saved.",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
                var cls = $A.get("e.force:closeQuickAction");
                helper.toggle(cmp,event,helper);
                cls.fire();
                
            } else if (saveResult.state === "INCOMPLETE") {
                var cls = $A.get("e.force:closeQuickAction");
                cls.fire();
                helper.toggle(cmp,event,helper);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Error",
                    "message": "There was an error saving the record. "+JSON.stringify(saveResult.error),
                    "type" : "error",
                    "error" : "error"
                });
                resultsToast.fire();
                var cls = $A.get("e.force:closeQuickAction");
                cls.fire();
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                // handle the error state
                helper.toggle(cmp,event,helper);
                var cls = $A.get("e.force:closeQuickAction");
                //cls.fire();
                var errMsg = "";
                // saveResult.error is an array of errors, 
                // so collect all errors into one message
                for (var i = 0; i < saveResult.error.length; i++) {
                    errMsg += saveResult.error[i].message + "\n";
                }
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Error",
                    "message": "There was an error saving the record. "+errMsg,
                    "type" : "error",
                    "error" : "error"
                });
                //resultsToast.fire();
                cmp.set("v.errormsg" ,errMsg);
                
                //console.log('Problem saving contact, error: ' + 
                //JSON.stringify(saveResult.error));
                
                //cmp.set("v.errormsg", errMsg);
                
            } else {
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Error",
                    "message": "There was an error saving the record. "+JSON.stringify(saveResult.error),
                    "type" : "error",
                    "error" : "error"
                });
                resultsToast.fire();
                console.log('Unknown problem, state: ' + saveResult.state +
                            ', error: ' + JSON.stringify(saveResult.error));
                // cmp.set("v.errormsg" ,saveResult.error );
            }
            
        });
    },
    recordUpdated : function(cmp, event, helper){
        
    },
})