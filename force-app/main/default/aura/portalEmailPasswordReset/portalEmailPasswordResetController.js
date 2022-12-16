({
	myAction : function(cmp, event, helper) {
        console.log('runningReset');
        console.log('Email givin '+cmp.get("v.emailUser"))
        var action = cmp.get("c.resetP");
        action.setParams({"emailUser" : cmp.get("v.emailUser")});
        action.setCallback(this,function(resp){
            let state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                var reset = resp.getReturnValue();
                cmp.set("v.userFoundReset" ,reset );
                var navigate = cmp.get('v.navigateFlow');
                navigate("NEXT");
                
            }else{
                console.log('error with password reset');
                let ermsg = resp.getError();
                console.log(ermsg);
                ermsg = ermsg[0].message;
                console.log('error ');              
                cmp.set("v.errMsg",'There was an error message. Please send support ticket with message. '+ermsg);
                console.log(ermsg+ ' error resetting password');
            }            
        });
        $A.enqueueAction(action);        
    }
})