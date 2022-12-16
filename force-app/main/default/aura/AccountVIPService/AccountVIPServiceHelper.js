({
    helperMethod : function() {
        
    },
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    }, 
    
    hotline : function (cmp,event,helper){
        console.log('helper running');
        var records = cmp.get("c.hotline");
        records.setParams({"recid" : cmp.get("v.recordId")});        
        records.setCallback(this,$A.getCallback( function(data) {
            console.log('data return ' + data.Id);
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Approval Sent",
                    "message": "Request was sent to bid desk, Then to your Manager, This does not approve the Spa!",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": cmp.get("v.recordId")
                });
                navEvt.fire();
                $A.get('e.force:refreshView').fire();
            }else{
                var errors = data.getError();
                var messages = ''; 
                //var i= ; 
                for(var i = 0; i < errors.length; i++){
                    messages = messages +'\n\n'+ errors[i].message;
                }
                alert(' '+messages);
            }
        }));
        $A.enqueueAction(records);
    }
    
})