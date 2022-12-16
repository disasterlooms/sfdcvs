({
    addTaks : function(cmp, event, helper) {
        var action = cmp.get("c.assignTaks");
        let con = cmp.get("v.con");
        console.log('con id '+ con)
        action.setParams({
            "conId": con
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                var navigate = cmp.get('v.navigateFlow');
                navigate("NEXT");
            }
            else{
                console.log('error creating task');
                let ermsg = resp.getError();
                ermsg = ermsg[0].message;
                //cmp.set("v.errMsg",'There was an error messgae. Please send support ticket with message. '+ermsg);
                console.log('Error Message '+ ermsg);
                var navigate = cmp.get('v.navigateFlow');
                navigate("NEXT");
            }
        });
        $A.enqueueAction(action);
    }
})