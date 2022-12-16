({
    getDashboards : function(cmp, event, helper) {
        
        
        
        var action = cmp.get("c.getOppLInes");
        action.setParams({
            "dgroup" : 'sales directors'
        });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                cmp.set("v.dashboards",data.getReturnValue());
                console.log('results');
                console.log(data.getReturnValue());    
            }else{
            }
        });
        $A.enqueueAction(action);
        
        
        
        
    }
})