({
	myAction : function(cmp, event, helper) {
        console.log('action running');
		console.log(cmp.get("c.getRecId"));
        var action = cmp.get("c.getRecId");
        action.setParams({
            "recordId":cmp.get("v.recordId")
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                console.log(resp.getReturnValue());
                var relrecord = resp.getReturnValue();
                cmp.set("v.relatedRecId",relrecord);
                cmp.set("v.objType",relrecord.substring(0,3));
            }
            else{
                alert(resp.getError());
            }
        });
        $A.enqueueAction(action);
	}
})