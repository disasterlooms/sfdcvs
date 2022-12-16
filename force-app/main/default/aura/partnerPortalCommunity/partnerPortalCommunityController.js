({
	checkDomain : function(cmp, event, helper) {
		console.log('init running');
        var action = cmp.get("c.getDomain");
        console.log(cmp.get("v.domain")+' domain ');
        action.setParams({
            "thedomain" : cmp.get("v.domain")
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                var retVal = resp.getReturnValue();    
                cmp.set("v.isGeneric",retVal);
                console.log('ret value '+ retVal);
                if(!retVal){
                    helper.requestCode(cmp,event,helper);
                }
                
            }
            else{
                // alert(resp.getError());
                console.log('error gettin domain info');
                console.log(resp.getError());
            }
        });
        $A.enqueueAction(action);
	}
})