({
	helperMethod : function() {
		
	},
    getTaskInfo : function(cmp,event,helper){
      let action = cmp.get('c.getTasks ');
      action.setParams({conId : '',
                          wherestmnt  : '',
                          addfields  : '',
                          orderstmnt  : ' order by Partner_Portal_Task__r.Order_Priority__c asc'
                          
                         });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
            var tsk = response.getReturnValue();
            console.log('tasks success');
            console.log(tsk);
            cmp.set("v.tasks",tsk);
                
        }else{
            console.log('there was an error, need better error reporting');
            //helper.hideSpinner(cmp,event,helper);
            var errors = response.getError();  
            console.log(errors[0].message);
        }
      });
      $A.enqueueAction(action);
    }
})