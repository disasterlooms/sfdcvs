({
	getAliases : function(cmp,event,helper) {
        console.log('running init');
        var action = cmp.get("c.getAliases ");
        var aliasname = cmp.get("v.aliasname");
        console.log('alias '+aliasname);
        action.setParams({
            "aname": aliasname
        });	
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {   
                var dta = response.getReturnValue();
                cmp.set("v.aliases",dta);
                console.log(dta);
            }else{
                
              alert('error getting records');
                
            }
        });
 
        $A.enqueueAction(action);
	}
})