({
    myAction : function(cmp, event, helper) {
        helper.helperMethod(cmp,event,helper);
        helper.addspinner(cmp,event,helper);
        
    },
    handleSubmit : function(cmp,event,helper){
        window.scrollTo(100, 0);
        helper.addspinner(cmp,event,helper);
        console.log('running submit');
        //console.dir(cmp);
        //console.log(cmp);
        console.log(event);
        event.preventDefault();
        //cmp.set("v.order.AccountId",cmp.get("v.acct.Id"));
        cmp.set("v.order.Status","Draft");
        console.log('order acct id '+ cmp.get("v.order.AccountId"));
        //cmp.set("v.order.PriceBook2Id","01sA0000000PgsV");
        var action = cmp.get("c.upOrder");
        action.setParams({
            "o" : cmp.get("v.order")
        });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){data.getReturnValue()
            console.log(data.getReturnValue());
                                    helper.removespinner(cmp,event,helper);
                                    helper.toast(cmp,event,helper);
                                    cmp.set("v.order",null);
                                    console.log('success');
                                    var successOrder = cmp.getEvent("orderCreated");                                 
                                    
                                    successOrder.fire();
                                    //$A.get('e.force:refreshView').fire();                    
                                    console.log('inter comp event order created'); 
                                    
                                    
                                   }else{
                                       helper.removespinner(cmp,event,helper);
                                       console.log('error1');
                                       var errors = data.getError();
                                       console.log(errors[0].message);
                                       //console.log(errors);
                                       cmp.set("v.errMessage",errors[0].message);
                                       helper.toastError(cmp,event,helper);
                                       //alert('Sorry, there was an error, please let admin know');
                                   }
        });
        $A.enqueueAction(action);
    },
    handleError : function(cmp,event,helper){
        console.log('error for handle error');
        var error = event.getParams();
        var errorMessage = event.getParam("message");
        var erroroutput = event.getParam("output");
        console.log(erroroutput); 
        console.log(errorMessage);
        
        //console.log(Errors);
        //console.log(Errors[0]);
        /*
        var errors = response.getError();
                console.log(errors[0].message);
                console.log(errors);
                */
    },
    handleSuccess : function(cmp,event,helper){
        
        
        
    },
    loadedValues : function(cmp,event,helper){
        /*
        var edate = cmp.get("v.order.EffectiveDate");
        if(edate == undefined || edate == null){            
            var n = Date(Date.now());
            console.log('date '+n);
             n = $A.localizationService.formatDate(n,"MMM d, yyyy");
            console.log('use formate date '+n);
          
            cmp.set("v.order.EffectiveDate",n);
            
            var dobcmp = component.find("effecdate");
            dobcmp.setCustomValidity('') ;
            var chckvalididty = dobcmp.get("v.validity");
            console.log(chckvalididty.valid); // it gives false when 1st enter wrong format then i changed to correct format still shows
            if(!chckvalididty.valid){
                dobcmp.setCustomValidity('format must be mm/dd/yyyy');
            }else{
                dobcmp.setCustomValidity('') ;
            }
            dobcmp.reportValidity();
           
            
        }
         */
    },    
    
})