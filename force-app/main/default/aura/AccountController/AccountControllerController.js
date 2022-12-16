({
	getAccount : function(cmp) {
        var action = cmp.get("c.getRecord");
        var recid = cmp.get("v.recordId");
        console.log('acctget running');
        
        action.setParams({
            "recid": cmp.get("v.recordId")
        });
        action.setCallback(this,function(resp){
            console.log('running callback from controller');
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                cmp.set("v.account",resp.getReturnValue());
                console.log('ret val acct vip');
                console.log(resp.getReturnValue());
            }
            else{
                console.log('error');
                //alert(resp.getError());
            }
        });
        $A.enqueueAction(action);
        console.log('get recid and acct id');
        console.log(recid);
    }
})