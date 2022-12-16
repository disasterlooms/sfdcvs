({
	helperMethod : function() {
		
	},
    getmssgs : function(cmp,event,handler) {
        console.log('searching');
        var action = cmp.get("c.getMessagefromspa");
        action.setParams({
            "spaid": cmp.get("v.spaid")
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                
                var quoteid = resp.getReturnValue();
                console.log(quoteid);
                if(quoteid != ''){
                    cmp.set("v.recordId",resp.getReturnValue());
                    
                }else{
                    cmp.set("v.nospa", true);
                    console.log('blank value');
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Invalid Spa ID",
                        "message": "No Results Found",
                        "type" : "error",
                        "key" : "error"
                    });
                    resultsToast.fire();
                }
            }
            else{
                alert(resp.getError());
            }
        });
        $A.enqueueAction(action);
	},
    
})