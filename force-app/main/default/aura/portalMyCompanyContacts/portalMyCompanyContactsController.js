({
	myAction : function(component, event, helper) {
		
	},
    getContactInfo : function(cmp,event,helper){
        console.log('gete the info');
        var action = cmp.get("c.getUsers");
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                console.log('good to go on results');
                var retVal = resp.getReturnValue();
                cmp.set("v.contacts",retVal);
                cmp.set("v.unfilteredContacts",retVal);
                
                console.log(retVal);
                if(resp.getReturnValue().length > 0){
                    cmp.set("v.showCons",true);
                }else{
                    cmp.set("v.showCons",false);
                }
                helper.removeSpinner(cmp,event,helper);
            }
            else{
                console.log('error on reslts');
                let ermsg = resp.getError();
                ermsg = ermsg[0].message;
                cmp.set("v.errMsg",'There was an error messgae. Please send support ticket with message. '+ermsg);
                console.log(resp.getError());
                helper.removeSpinner(cmp,event,helper);
            }
        });
        $A.enqueueAction(action);
	
    
    
    },
    manageThis : function(cmp,event,helper){
        console.log('manage this');
        let userid = event.getSource().get("v.title");
        let conid =  event.getSource().get("v.value");
        cmp.set("v.userId",userid);
        cmp.set("v.conId",conid);        
        console.log(' user and con id '+userid+' '+conid);
        var navigate = cmp.get('v.navigateFlow');
        navigate('NEXT');
        
    }, 
    searchList : function(cmp,event,helper){
        helper.searchFun(cmp,event,helper);
    },
    handleKeyUp : function(cmp,event,helper){
        if (event.which == 13){ 
            console.log('enter key');
            helper.showSpinner(cmp,event,helper);
            helper.searchFun(cmp,event,helper);
        }
    }
})