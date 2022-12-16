({
    oline : function(cmp,event,helper){        
        cmp.set("v.showModal",true);
        var  nlineid = event.getSource().get("v.title");
        
       var modalFooter;
       var modalBody;
   			$A.createComponents([
                ["c:ScheduleMulti",{ lineid : nlineid}],
                ["c:modalFooter",{}]
            ],
           function(components , status) {
               if (status === "SUCCESS") {
                   modalBody = components [0];
                   //modalFooter = components[1];
                   cmp.find('overlayLib1').showCustomModal({
                       header: "Update Schedule and Save",
                       body: modalBody,
                       footer: modalFooter,
                       showCloseButton: true,
                       cssClass: "mymodal slds-modal_medium",
                       closeCallback : function() {
                       }
                   })
               }                               
           });       
         /*
        var childCmp = component.find("multsch")
        childCmp.sampleMethod();
        
       
        var  nlineid = event.getSource().get("v.title");
        cmp.set("v.olineId",nlineid);
        
        console.log('linid '+nlineid);
         var navService = cmp.find("navService");
       
        var pg = {
            type: 'standard__component',
            attributes: {
                componentName: 'ScheduleMulti',
            },
            state: {
                "olineId": nlineid
            }
        };
        
        event.preventDefault();
        console.log(pg);
        console.log('pg');
        navService.navigate(pg);
        
        
        
        */
    },
    myAction : function(cmp, event, helper) {
         helper.getOpps(cmp,event,helper);
        
        var val = cmp.get("v.olineId");
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'ScheduleMulti',
            },
            state: {
                "olineId": val
            }
        };
        
        cmp.set("v.pageReference", pageReference);
        
        
    },
    enterKey : function(cmp, event, helper) {
        if (event.keyCode === 13) {
            helper.getOpps(cmp,event,helper);
        }
    },
    sorteu : function(cmp,event,helper){
        var enduser = cmp.find("enduser");
        var state = cmp.find("industry");
        var industry = cmp.find("state");
        
        enduser.set("v.issortfield",true);
        state.set("v.issortfield",false);
        industry.set("v.issortfield",false);
        
        state.set("v.direction","asc");
        industry.set("v.direction","asc");
        
        state.set("v.sortdirection","utility:arrowdown");
        industry.set("v.sortdirection","utility:arrowdown");
        
        var sortfield = cmp.find("enduser").get("v.issortfield");
        var comp = cmp.find("enduser");
        var sortdir = comp.get("v.direction");
        console.log(comp);
        
        if(sortdir == "desc"){
            comp.set("v.sortdirection","utility:arrowup");
            comp.set("v.direction","asc");
            cmp.set("v.sortfield","Account.Name");
            cmp.set("v.sortorder","asc");
        }else{         
            
            comp.set("v.sortdirection","utility:arrowdown");
            comp.set("v.direction","desc");
            cmp.set("v.sortfield","Account.Name");
            cmp.set("v.sortorder","desc");
        }
        helper.getOpps(cmp,event,helper);
        
        
        console.log(cmp.find("enduser").get("v.sortdirection"));
    },
    sortstate : function(cmp,event,helper){
        var enduser = cmp.find("enduser");
        var state = cmp.find("state");
        var industry = cmp.find("industry");
        
        enduser.set("v.issortfield",false);
        state.set("v.issortfield",true);
        industry.set("v.issortfield",false);
        
        enduser.set("v.direction","asc");
        industry.set("v.direction","asc");
        
        enduser.set("v.sortdirection","utility:arrowdown");
        industry.set("v.sortdirection","utility:arrowdown");
        
        var comp = cmp.find("state");
        var sortdir = comp.get("v.direction");
        if(sortdir == "desc"){
            comp.set("v.sortdirection","utility:arrowup");
            comp.set("v.direction","asc");
            
            cmp.set("v.sortfield","Account.BillingState");
            cmp.set("v.sortorder","asc");
        }else{
            
            
            comp.set("v.sortdirection","utility:arrowdown");
            comp.set("v.direction","desc");
            
            cmp.set("v.sortfield","Account.BillingState");
            cmp.set("v.sortorder","desc");
        }
        helper.getOpps(cmp,event,helper);
    },
    
    sortind : function(cmp,event,helper){
        var enduser = cmp.find("enduser");
        var state = cmp.find("state");
        var industry = cmp.find("industry");
        
        enduser.set("v.issortfield",false);
        state.set("v.issortfield",false);
        industry.set("v.issortfield",true);
        
        enduser.set("v.direction","asc");
        state.set("v.direction","asc");
        
        enduser.set("v.sortdirection","utility:arrowdown");
        state.set("v.sortdirection","utility:arrowdown");
        
        var comp = cmp.find("industry");
        var sortdir = comp.get("v.direction");
        if(sortdir == "desc"){
            comp.set("v.sortdirection","utility:arrowup");
            comp.set("v.direction","asc");
            
            cmp.set("v.sortfield","Account.Industry");
            cmp.set("v.sortorder","asc");
        }else{
            
            
            comp.set("v.sortdirection","utility:arrowdown");
            comp.set("v.direction","desc");
            
            cmp.set("v.sortfield","Account.Industry");
            cmp.set("v.sortorder","desc");
        }
        
        helper.getOpps(cmp,event,helper);
    },
    forward : function(cmp,event,helper){
        var ofset = cmp.get("v.ofset");
        cmp.set("v.ofset",ofset+25);
        helper.getOpps(cmp,event,helper);        
        
    },
    back : function(cmp,event,helper){
        var ofset = cmp.get("v.ofset");
        cmp.set("v.ofset",ofset-25);
        helper.getOpps(cmp,event,helper);        
        
    },
    goToOpp : function(cmp,event,helper){
        var recid = event.getSource().get("v.value"); 
        window.open('/' + recid);  
        /*
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recid
        });
        navEvt.fire();
        */
    },
    focused : function(cmp,event,helper){
        console.log('input focused..do something');
    },
    clicked : function(cmp,event,helper){
        console.log('clicked');
    },
    addProds : function(cmp,event,helper) {
        console.log('save opps');
        helper.toggle(cmp,event,helper);   
        var opportunities = cmp.get("v.opps");
        var action = cmp.get("c.saveOpps");
        action.setParams({
            "ops": opportunities
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                helper.toggle(cmp,event,helper);
                helper.getOpps(cmp,event,helper);                
                console.log('state ');
                console.log(response.getReturnValue());
                var mssg = response.getReturnValue();
                if(mssg == 'success'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The record(s) were updated successfully.",
                        "type": "success"
                    });
                    toastEvent.fire();
                    
                }else{
                    toastEvent.setParams({
                        "title": "There were Errors",
                        "warning": "Some record(s) were not saved "+mssg,
                        "type": "warning"
                    });
                    toastEvent.fire();
                    
                }
            }
            else if (state === "ERROR") {
                helper.hidespinner(cmp,event,helper);
                var errors = response.getError();
                if (errors) {
                    //$A.logf("Errors", errors);
                    if (errors[0] && errors[0].message) {
                        
                        alert(' error'+errors[0].message);
                    }
                } else {
                    //$A.error("Unknown error");
                    helper.hidespinner(cmp,event,helper);
                    console.log(' unknown');
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    proddel : function(cmp,event,helper){
        var pid = event.getSource().get("v.value");
        console.log('event '+pid);
        var action = cmp.get("c.unliklyprod");
        action.setParams({
            "prodid": pid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                /*
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Removed from schedule",
                    "type": "success"
                });
                toastEvent.fire();
                */
                helper.getOpps(cmp,event,helper);  
            }else{
                /*
                toastEvent.setParams({
                    "title": "Error",
                    "message": "There was an error, please notify admin",
                    "type": "error"
                });
                toastEvent.fire();
                */
            }
        });
        $A.enqueueAction(action);
    },
    
})