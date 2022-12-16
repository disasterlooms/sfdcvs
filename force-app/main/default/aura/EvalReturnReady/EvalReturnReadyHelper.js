({
	helperMethod : function() {
		
	},
    showunits : function(cmp, event, helper){
        var recid = cmp.get("v.recordId");
        console.log('helper recid');
        console.log(recid);
        var action = cmp.get("c.getUnits");
        action.setParams({"recordId": recid
                         });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                cmp.set("v.units", data.getReturnValue());
                console.log(data.getReturnValue());   
            }else{
                alert(rslt.getError()); 
            }
        });
        $A.enqueueAction(action);
    },
})