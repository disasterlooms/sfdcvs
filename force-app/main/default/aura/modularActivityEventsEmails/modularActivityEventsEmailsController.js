({
	myAction : function(cmp, event, helper) {
        console.log('init runnign activities '+ cmp.get("v.recordId"));
       var action = cmp.get("c.getRecId");
       var recid = cmp.get("v.recordId");
        
        action.setParams({
            "recordId": recid
        });
        
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                console.log('get related rec id '+ resp.getReturnValue());
                var retValue = resp.getReturnValue();
                cmp.set("v.events",retValue[1]);
                cmp.set("v.tasks",retValue[0]);
                cmp.set("v.emails",retValue[2]);
                
                console.log('list values');
                console.log(retValue);
               
                
                
            }
            else{
                alert(resp.getError());
            }
        });
        $A.enqueueAction(action);
		
	}
})