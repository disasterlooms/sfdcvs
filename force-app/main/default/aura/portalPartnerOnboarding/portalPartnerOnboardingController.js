({
	sPassword : function(cmp, event, helper) {
        console.log('run accoutns');
        let action = cmp.get("c.mapAccount");
        action.setParams({
            cemail : cmp.get("v.conEmail") });
        action.setCallback(this,function(resp){
            let state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                console.log('gettingAccounts ');
                let retVal = resp.getReturnValue();
                cmp.set("v.accounts",retVal);
                console.log('retVal '+retVal);
                if(retVal.length  > 0){
                    cmp.set("v.acctFound",true);
                        
                }else{
                    var navigate = cmp.get("v.navigateFlow");
                    navigate("NEXT");
                    console.log('no acct found, should click next');
                    //cmp.set("v.acctFound",false); 
                }
                helper.hideSpinner(cmp,event,helper);
            }
            
            //var eMsg = $A.get("$Label.c.errorMessageJS");
            else{
                // alert(resp.getError());
                console.log('error gettin domain info');
                let ermsg = resp.getError();
                ermsg = ermsg[0].message;
                cmp.set("v.errMsg",$A.get("$Label.c.errorMessageJS")+' '+ermsg);
                console.log(resp.getError());
                helper.hideSpinner(cmp,event,helper);
            }
        });
        $A.enqueueAction(action);
	},
    updateAcct : function(cmp,event,helper){
        let acct =  event.getSource().get("v.value");
         let owner =  event.getSource().get("v.name");
        console.log('accid '+acct);
        cmp.set("v.acctId", acct);
        cmp.set("v.acctOwnerId", owner);
        console.log('owenr id '+owner);
        var checkbox = cmp.find("DependentCheckboxpart");
        var checkboxes = [];
        if(checkbox.length == undefined){
           checkboxes.push(checkbox); 
        }else{            
            checkboxes = checkbox;
        }
         for (var i = 0; i < checkboxes.length; i++){
             if(checkboxes[i].get("v.value") !=acct ){
               
              checkboxes[i].set("v.checked",false);   
             }             
         }
        cmp.set("v.btnDisabled",false);
        cmp.set("v.btnDisabled",false);
        
    },
    incorrect : function(cmp,event,helper){
        console.log('on change or on click');
        cmp.set("v.btnDisabled",false);
        
    },
    
    nextFlow : function(cmp,event,helper){
        var navigate = cmp.get("v.navigateFlow");
        navigate("NEXT");
    }
})