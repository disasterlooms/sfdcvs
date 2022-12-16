({
    myAction : function(cmp, event, helper) {
        helper.addspinner(cmp,helper,event);
        console.log(cmp.get("v.steps"));
        console.log('stesp');
        var steps = [];
        
        steps.push({
            name: 'Super Admin',
            step: '1'
        });
        steps.push({
            name: 'IT Management - Owner Account - Configuration and Setup of Entity',
            step: '2'
        });
        /*
        steps.push({
            name: 'Entity Application Owner – Management of User Community and Instances',
            step: '3'
        });
        steps.push({
            name: 'Instructional Coach  – Professional Development and Training',
            step: '4'
        });
        steps.push({
            name: 'IT Information',
            step: '5'
        });
        */
        cmp.set('v.steps', steps);
        console.log('steps var');
        console.log(steps);
        console.log(cmp.get("v.steps")[1].name);
        var contacts = [];
        for (var i = 0; i < 4; i++){                   
            var usertype ='';
            if(i == 0){
               usertype = 'Super Admin'; 
            }else if(i==1){
               usertype = 'Application Owner';  
            }
            contacts.push({
                'sobjectType': 'Contact',
                "AccountId" : cmp.get("v.acct"),
                "FirstName" : '',
                "LastName" : '',
                "Email" : '' ,
                "Phone" : '',
                "ViewBoard_User_Type__c" : usertype,
                "ViewSchool__c" : '',
                "Marketing_Post_Sales__c" : '',
                "SameasLRP" : false,
            });
        }
        cmp.set("v.contacts",contacts);
        console.log('contacts');
        console.log(contacts);
        helper.removespinner(cmp,helper,event);
        
        
    },
    previous : function(cmp, event, helper) {
        var step = cmp.get("v.step");
        var progress = cmp.get("v.progress"); 
        
        cmp.set("v.step",step-1);
        cmp.set("v.progress",progress-25);
        helper.sameasLRP(cmp,event,helper);
    },
    handleSave: function(cmp, event, helper) {
        helper.addspinner(cmp,event,helper);
        var cons = cmp.get("v.contacts");
        console.log('this is array being sent contats');
        console.log(cons);
        var action = cmp.get("c.createCons");
        action.setParams({
            "con" : cons,
        });
        console.log('what cons sending');
        console.log(cons);
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                console.log('success');
                console.log('ret value of saving cons '+resp.getReturnValue());
                cmp.set("v.ready",true);
                helper.removespinner(cmp,event,helper);
                var toastEvent = cmp.getEvent("showToast");
                toastEvent.fire();
                
            }
            else{
                // alert(resp.getError());
                helper.removespinner(cmp,event,helper);
                console.log('erroradding account');
                console.log(resp.getError());
                var ermsg = resp.getError();
                console.log(ermsg[0].message);
                var ermsgret = ermsg[0].message;
                cmp.set("v.erromsg",ermsgret);
                helper.toastError(cmp,event,helper);
            }
        });
        $A.enqueueAction(action);
    },
    handleNext: function(cmp, event, helper) {
        console.log('saving con 1');
        helper.addspinner(cmp,event,helper);
        var step = cmp.get("v.step"); 
        if(step == 3 || step == 4){
            helper.advanceStep(cmp,event,helper);
        }else{
            helper.validation(cmp,event,helper);
        }
        console.log(cmp.get("v.contacts"));
    },
    skip : function(cmp, event, helper) {
        helper.addspinner(cmp,event,helper);
        helper.advanceStep(cmp,event,helper)
        
    },
    sameprv : function(cmp, event, helper) {
        helper.addspinner(cmp,event,helper);
        cmp.set("v.contacts[1].SameasLRP",true);
        helper.advanceStep(cmp,event,helper);
        helper.sameasLRP(cmp,event,helper);
        
    },
    lrpSameChange : function(cmp, event, helper) {
        //helper.addspinner(cmp,event,helper);
        console.log('lrpsmacheck');
        var same = cmp.get("v.contacts[1].SameasLRP");
        console.log(same);
        if(same== true){
            helper.advanceStep(cmp,event,helper);
            helper.sameasLRP(cmp,event,helper);
            
        }else{
            cmp.set("v.contacts[1].FirstName",'');
            cmp.set("v.contacts[1].LastName",'');
            cmp.set("v.contacts[1].Email",'');
            cmp.set("v.contacts[1].Phone",''); 
        }
    },
    handleSubmit :  function(cmp, event, helper) {
        event.preventDefault(); // stop form submission
        var fields = event.getParam('fields');     
        fields.Id = cmp.get("v.acct");
        console.log(fields.Id);
        
        helper.addspinner(cmp,event,helper);
        console.log('this is acct being sent contats');
        console.log(fields);
        var action = cmp.get("c.updateAcct ");
        action.setParams({
            "acct" : fields,
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                console.log('success account');
                console.log('ret value of saving acct '+resp.getReturnValue());
                cmp.set("v.acctTypeInfo",false);
                
                //cmp.set("v.ready",true);
                helper.removespinner(cmp,event,helper);
                //var toastEvent = cmp.getEvent("showToast");
                //toastEvent.fire();
                
            }
            else{
                // alert(resp.getError());
                helper.removespinner(cmp,event,helper);
                console.log('error updating account');
                console.log(resp.getError());
                var ermsg = resp.getError();
                console.log(ermsg[0].message);
                var ermsgret = ermsg[0].message;
                cmp.set("v.erromsg",ermsgret);
                helper.toastError(cmp,event,helper);
                cmp.set("v.acctTypeInfo",true);
            }
        });
        $A.enqueueAction(action);
        
        
        //eventFields["Id"] = cmp.get("v.acct");        
        //cmp.find('myformacct').submit(eventFields);
    },
    handleSuccess :  function(cmp, event, helper) {
        
    },
    handleError :  function(cmp, event, helper) {
    },
    handleLoad : function(cmp,event,helper){
        cmp.set("v.disabled",false);
    }
    
})