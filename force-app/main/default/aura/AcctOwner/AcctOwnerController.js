({
	myAction : function(component, event, helper) {
		
	},
    cancel : function(cmp,event,helper){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    handleSubmit : function(cmp, event, helper) {
        cmp.set("v.disabled",true);
        console.log('sumbit');
    },
    handleSuccess : function(cmp, event) {
        var action = cmp.get("c.ownerUp");
        action.setParams({
            recid : cmp.get("v.recordId")
        });
        action.setCallback(this, function(data) {
       var rslt = data.getState();
            if (rslt === "SUCCESS"){
                var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Fields Updated ",
            "message": "Owner Updated in 24 Hours and Based on ViewSonic Territory/Account Rules",
            "type" : "success",
            "key" : "approval"
        });
        resultsToast.fire();
        $A.get('e.force:refreshView').fire();
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
            }else{
                 var errors = data.getError();
                 var messages = ''; 
                 //var i= ; 
                 for(var i = 0; i < errors.length; i++){
                    messages = messages +'\n\n'+ errors[i].message;
                }
                alert(' '+messages);
            }
        });        
        $A.enqueueAction(action); 
        
        
    },
    handleLoad : function(cmp,event,helper){
        
    }
})