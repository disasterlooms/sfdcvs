({
	unShipped : function(cmp, event, helper) {
        console.log('get evals');
        var action = cmp.get("c.getEvals");
        action.setParams({"recid": cmp.get("v.recordId")
                         });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
       		if (rslt === "SUCCESS"){            	
        		cmp.set("v.evals", data.getReturnValue());
                cmp.set("v.recordId", '123');
            }else{
            }
        }); 
        $A.enqueueAction(action);
        
		
	},
    evalRec : function(cmp, event, helper) {
        alert('test');
        var evalid = event.getSource().get("v.value");
        console.log('eval id ' +evalid);
        alert('eval id ' +evalid);
        
		
	}
})