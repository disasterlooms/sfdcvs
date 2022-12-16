({
    myAction : function(component, event, helper) {acct
    
                                                  },
    handleSubmit : function(cmp,event,helper){
        helper.addspinner(cmp,event,helper);
        event.preventDefault();
        var eventFields = event.getParam("fields");
        eventFields["Status"] = "New";
        eventFields["Subject"] = "Edu Portal User Created Product Issue";
        eventFields["Origin"] = "Education Portal";
        eventFields["AccountIdText__c"] = cmp.get("v.acct");
        if(cmp.get("v.type") == '' || cmp.get("v.desc") == '' 
           || cmp.get("v.name") == '' || cmp.get("v.email") == ''){
            alert('Please enter Name, Email, Description, and Inquiry Type');
            helper.removespinner(cmp,event,helper);
        }else{
            cmp.find('caseSubmission').submit(eventFields);
        }
        
    },
    handleSuccess : function(cmp,event,helper){
        helper.removespinner(cmp,event,helper);
        helper.toast(cmp,event,helper);
        cmp.set("v.name",'');
        cmp.set("v.phone",'');
        cmp.set("v.email",'');
        cmp.set("v.serial",'');
        cmp.set("v.time",'');
        cmp.set("v.desc",'');
        cmp.set("v.type",'');
        
    },
    handleError : function(cmp,event,helper){
        helper.removespinner(cmp,event,helper);
    },
})