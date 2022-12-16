({
	deactivate : function(cmp, event, helper) {
		console.log('gete the info');
        var action = cmp.get("c.inactive");
        action.setParams({conid: cmp.get("v.conId"),
                          userid :  cmp.get("v.userId")                          
                         });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                console.log('success');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "mode": "sticky",
                    "type": "success",
                    "title": "The User has been updated successfully.",
                    "message": "It may take a few minutes for the update to complete and may still show on list for a few minutes"
                });
                toastEvent.fire();
                let act = cmp.get("v.flowAction");
                var navigate = cmp.get('v.navigateFlow');
                navigate(act);
            }
            else{
                console.log('error on reslts');
                var errMsg = resp.getError();
                console.log(errMssg);
                errMssg = errMsg[0];
                console.log(errMssg);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "mode": "sticky",
                    "type": "error",
                    "title": "Error!",
                    "message": "Admin has been notified of an error, "+errMssg
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
	}
})