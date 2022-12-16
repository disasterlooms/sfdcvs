({
	updateClaimsInfo : function(cmp, event, helper) {
        var action = cmp.get("c.updateFinance");        
        action.setParams({});
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                 console.log('success on updating contact spiff info');
                var navigate = cmp.get('v.navigateFlow');
                navigate('NEXT');
                 helper.hideSpinner(cmp,event,helper);
            }
            else{
                console.log('got error on updating contact spiff info');
                console.log(resp.getError());
                var erm = resp.getError();
                console.log(erm[0]);
                erm= erm[0].message;
                cmp.set("v.errMssg",' There was an error: send the following to admin:      '+ erm);
                helper.hideSpinner(cmp,event,helper);
            }
        });
        $A.enqueueAction(action);
        console.log('show account info');
        console.log(cmp.get("v.account"));
	}
})