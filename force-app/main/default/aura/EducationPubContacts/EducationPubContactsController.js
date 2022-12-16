({
    myAction : function(component, event, helper) {
        
    },
    gettingCons : function(cmp,event,helper){
         helper.getCons(cmp,event,helper);
        
    },
    handleSubmit : function(cmp,event,helper){
        helper.addspinner(cmp,event,helper);
        console.log('submit');
        var action = cmp.get("c.updateContacts");
        var contacts = cmp.get("v.cons");
        var i = 0;
        for (i = 0; i < contacts.length; i++) {
           if(contacts[i].ViewBoard_User_Type__c == 'Admin'){
			contacts[i].ViewBoard_User_Type__c = 'Super Admin';
           }
       }

        
        action.setParams({
            "cons": contacts
        });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                helper.removespinner(cmp,event,helper);
                helper.toast(cmp,event,helper);
				//var navigate = cmp.get("v.navigateFlow");
                //navigate("NEXT");
            }else{
                //helper.spinnerhide(cmp, event,helper); 
                helper.removespinner(cmp,event,helper);
                let errors = data.getError();
                if(errors[0].message){
                    console.log(errors[0].message);
                    errors = errors[0].message;
                }else{
				console.log(errors[0].pageErrors[0].message);
                console.log(errors[0].pageErrors[0].statusCode);
				errors =  errors[0].pageErrors[0].message;               
                }
                
                alert('Sorry, there was an error, please let admin know and give this message : '+errors);
            }
        });
        $A.enqueueAction(action);
    },
    handleAdd : function(cmp,event,helper){
        var flow = cmp.get("v.fromFlow");
        console.log(flow);
        if(flow == false){
             cmp.set("v.showmodal",'');
        }else{
            cmp.set("v.showConForm",true);
            console.log('set aura show');
            
        }
       
        
    },
    hideModal : function(cmp,event,helper){
        console.log('event triggered');
        cmp.set("v.showmodal",'slds-hide');
    },
    toastconAdd : function(cmp,event, helper){
        helper.getCons(cmp,event,helper);
        helper.toast(cmp,event,helper);
        
    }, 
    
    
})