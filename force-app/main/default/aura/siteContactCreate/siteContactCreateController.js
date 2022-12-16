({
	myAction : function(component, event, helper) {
		
	},
    cancel :function(cmp,event,helper){
        console.log('cancelling');
        var updateEvent = cmp.getEvent("closeModal");
        updateEvent.fire();
        console.log(updateEvent);
    },
     handleSave: function(cmp, event, helper) {
        console.log('handle save');
        helper.addspinner(cmp,event,helper);
        var cons = cmp.get("v.con");
        cons.AccountId = cmp.get("v.AccountId");
        //cons.Marketing_Post_Sales__c  = true;
         
        console.log('this is contact being sent contats');
        console.log(cons);
        var action = cmp.get("c.createCon");
        action.setParams({
            "con" : cons,
        });
        
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                console.log('success');
                console.log('ret value of saving cons '+resp.getReturnValue());                
                helper.removespinner(cmp,event,helper);
                var updateEvent = cmp.getEvent("closeModal");
                var toastEvent = cmp.getEvent("showToast");
                cmp.set("v.con",null);
                
                updateEvent.fire();
                toastEvent.fire();
                //$A.get('e.force:refreshView').fire();
            }
            else{
                // alert(resp.getError());
                helper.removespinner(cmp,event,helper);
                console.log('erroradding account');
                console.log(resp.getError());
            }
        });
         $A.enqueueAction(action);
    }
})