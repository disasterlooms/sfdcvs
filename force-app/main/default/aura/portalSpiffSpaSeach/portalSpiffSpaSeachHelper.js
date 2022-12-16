({
    helperMethod : function() {
        
    },
    getRecords : function(cmp,event,helper){      
        console.log('get records');
        let action = cmp.get("c.getSpas");
        let spaId = cmp.get("v.spa");
        //console.log('spa id '+ spaId+ ' acct id '+ acctId);
        action.setParams({
            spaName : spaId
        });
        //console.log(cmp.get("v.spa"));
        action.setCallback(this,function(resp){
            let state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                console.log('gettingSpaData sucess');
                let retVal = resp.getReturnValue();
                cmp.set("v.spas",retVal);
                console.log(retVal);
                if(retVal.length  > 0){
                    cmp.set("v.acctFound",true);
                    helper.hideSpinner(cmp,event,helper);
                }else{
                    var navigate = cmp.get('v.navigateFlow');
                    navigate("NEXT");
                    cmp.set("v.acctFound",false);
                    helper.hideSpinner(cmp,event,helper);
                }
            }
            else{
                // alert(resp.getError());
                console.log('error gettin spa account info');
                let ermsg = resp.getError();
                ermsg = ermsg[0].message;
                cmp.set("v.errMsg",'There was an error messgae. Please send support ticket with message. '+ermsg);
                console.log(ermsg[0].message);
                helper.hideSpinner(cmp,event,helper);
            }
        });
        $A.enqueueAction(action);
    },
    hideSpinner : function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    showSpinner : function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    }
})