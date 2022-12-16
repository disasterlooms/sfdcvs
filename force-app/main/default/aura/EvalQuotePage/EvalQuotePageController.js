({
    myAction : function(component, event, helper) {
        console.log('helper');
        helper.spinner(component, event, helper);
        helper.showunits(component, event, helper);
        component.find("quotecreator").getNewRecord(
            "Eval_Quote__c", // sObject type (entityAPIName) 
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newQuote");
                var error = component.get("v.newQuoteError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                }
                else {
                    console.log("Record template initialized: " + rec.sobjectType);
                }
            })
        );
        
    },
    state : function(cmp,event,helper){
        console.log('next');
        var rec = cmp.get("v.recordId");
        cmp.set("v.billingstate", rec);
        
    },
    rendereval : function(cmp,event,helper){
        //cmp.find("eval").get("e.reloadRecord").fire();
    },
    saveQuote : function(component, event, helper) {
        component.set("v.simpleNewQuote.Eval_Request__c" , component.get("v.simpleRecord.Id"));
        helper.spinner(component, event, helper);
        component.find("quotecreator").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
                component.set("v.quoteid" ,component.get("v.simpleNewQuote.Id"));
                console.log(component.get("v.quoteid"));
                helper.spinner(component, event, helper);
                helper.table(component,event,helper);
                
            } else if (saveResult.state === "INCOMPLETE") {
                helper.spinner(component, event, helper);
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                helper.spinner(component, event, helper);
                alert('Problem saving record, error: ' + 
                      JSON.stringify(saveResult.error));
            } else {
                helper.spinner(component, event, helper);
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    },
    
    bcon : function(cmp,event,helper){
        cmp.find("bcon").reloadRecord();
        console.log('reloaded bill con');
        console.log(cmp.get("v.simpleRecord.Id"));
        
    },
    bacct : function(component,event,helper){
        debugger;
        component.find("bacct").reloadRecord();
        var buttons = component.find('buttons');
        //$A.util.toggleClass(buttons, 'slds-hide');
        
        console.log('reloaded bill acct');
        //helper.spinner(component, event, helper);
        
    },
    billCon : function(cmp,event,helper){
        debugger;
        cmp.set("v.simpleNewQuote.Billing_Contact_Name__c" , cmp.get("v.bconRecord.FirstName")+' '+cmp.get("v.bconRecord.LastName"))
        cmp.set("v.simpleNewQuote.Billing_Contact_Email__c" , cmp.get("v.bconRecord.Email"));
        cmp.set("v.simpleNewQuote.Billing_Company_Name__c" , cmp.get("v.baccRecord.Name"));
        cmp.set("v.simpleNewQuote.Billing_Street__c" , cmp.get("v.baccRecord.BillingStreet"));
        cmp.set("v.simpleNewQuote.Billing_City__c" , cmp.get("v.baccRecord.BillingCity"));
        cmp.set("v.simpleNewQuote.Billing_State__c" , cmp.get("v.baccRecord.BillingStateCode"));
        cmp.set("v.simpleNewQuote.Billing_Zip_Postal__c" , cmp.get("v.baccRecord.BillingPostalCode"));
        cmp.set("v.simpleNewQuote.Billing_Country__c" , cmp.get("v.baccRecord.BillingCountry"));
        cmp.set("v.simpleNewQuote.Billing_Contact_Phone__c" , cmp.get("v.baccRecord.Phone"));
        console.log(cmp.get("v.bconRecord.LastName"));
        console.log('con name');
        
    }, 
    
    scon : function(cmp,event,helper){
        cmp.find("scon").reloadRecord();
        console.log('reloaded Shipping contact');
        console.log(cmp.get("v.simpleRecord.Id"));
        
    },      
    
    sacct : function(component,event,helper){
        //debugger;
        component.find("sacct").reloadRecord();
        var buttons = component.find('buttons');
        $A.util.toggleClass(buttons, 'slds-hide');
        console.log('reloaded Ship acct');
        //helper.spinner(component, event, helper);
        
    },
    shipCon : function(cmp,event,helper){
        console.log('shipping contact info');
        console.log( cmp.get("v.simpleRecord.Shipping_Contact_Name__c"));
        console.log(cmp.get("v.sconRecord.FirstName"));
        debugger;
        cmp.set("v.simpleNewQuote.Billing_Contact_Name__c" , cmp.get("v.sconRecord.FirstName")+' '+cmp.get("v.sconRecord.LastName"));
        cmp.set("v.simpleNewQuote.Billing_Contact_Email__c" , cmp.get("v.sconRecord.Email"));
        cmp.set("v.simpleNewQuote.Billing_Company_Name__c" , cmp.get("v.saccRecord.Name"));
        cmp.set("v.simpleNewQuote.Billing_Street__c" , cmp.get("v.saccRecord.BillingStreet"));
        cmp.set("v.simpleNewQuote.Billing_City__c" , cmp.get("v.saccRecord.BillingCity"));
        cmp.set("v.simpleNewQuote.Billing_State__c" , cmp.get("v.saccRecord.BillingStateCode"));
        cmp.set("v.simpleNewQuote.Billing_Zip_Postal__c" , cmp.get("v.saccRecord.BillingPostalCode"));
        cmp.set("v.simpleNewQuote.Billing_Country__c" , cmp.get("v.saccRecord.BillingCountry"));
        cmp.set("v.simpleNewQuote.Billing_Contact_Phone__c" , cmp.get("v.saccRecord.Phone"));
        //console.log(cmp.get("v.sconRecord.LastName"));
        console.log('con name');
        
    }, 
    
    // start Changes for Reseller Contact Info Jul-19  
    // 
     rcon : function(cmp,event,helper){
        // debugger;
        cmp.find("rcon").reloadRecord();
        console.log('reloaded reseller contact');
        console.log(cmp.get("v.simpleRecord.Id"));
          var buttons = cmp.find('rbutton');
        if((cmp.get("v.simpleRecord.Reseller_Contact_Name__c")=== undefined || cmp.get("v.simpleRecord.Reseller_Contact_Name__c")=== null)||(cmp.get("v.simpleRecord.Billing_Contact_Name__c") === cmp.get("v.simpleRecord.Reseller_Contact_Name__c"))){
                             $A.util.toggleClass(buttons, 'slds-hide');
        }
        
        
    },      
    
    racct : function(component,event,helper){
        //debugger;
        component.find("racct").reloadRecord();
       
        
        
      
        console.log('reloaded reseller acct');
        //helper.spinner(component, event, helper);
        
    },
    resellerCon : function(cmp,event,helper){
        console.log('reseller contact info');
        console.log( cmp.get("v.simpleRecord.Reseller_Contact_Name__c"));
        console.log(cmp.get("v.rconRecord.FirstName"));
        debugger;
        cmp.set("v.simpleNewQuote.Billing_Contact_Name__c" , cmp.get("v.rconRecord.FirstName")+' '+cmp.get("v.rconRecord.LastName"));
        cmp.set("v.simpleNewQuote.Billing_Contact_Email__c" , cmp.get("v.rconRecord.Email"));
        cmp.set("v.simpleNewQuote.Billing_Company_Name__c" , cmp.get("v.raccRecord.Name"));
        cmp.set("v.simpleNewQuote.Billing_Street__c" , cmp.get("v.raccRecord.BillingStreet"));
        cmp.set("v.simpleNewQuote.Billing_City__c" , cmp.get("v.raccRecord.BillingCity"));
        cmp.set("v.simpleNewQuote.Billing_State__c" , cmp.get("v.raccRecord.BillingStateCode"));
        cmp.set("v.simpleNewQuote.Billing_Zip_Postal__c" , cmp.get("v.raccRecord.BillingPostalCode"));
        cmp.set("v.simpleNewQuote.Billing_Country__c" , cmp.get("v.raccRecord.BillingCountry"));
        cmp.set("v.simpleNewQuote.Billing_Contact_Phone__c" , cmp.get("v.raccRecord.Phone"));
        //console.log(cmp.get("v.sconRecord.LastName"));
        console.log('con name');
        
    }, 
    
   // end Changes for Reseller Contact Info July-19 
    
    
    
    checkAllCheckboxes : function(cmp, event, helper) {
        var checkCmp = cmp.find("checkboxpart");
        var value = checkCmp.get("v.value");
        var checkboxes = cmp.find("DependentCheckboxpart");
        var i;
        for (var i = 0; i < checkboxes.length; i++){
            checkboxes[i].set("v.value",value);
        }
    },
    showBilling : function(component,event,helper){
        helper.table(component,event,helper);
        
    },
    startflow : function (cmp,event,helper) {
        helper.spinner(cmp, event, helper);
        console.log('updating')
        var checkboxes = cmp.find("DependentCheckboxpart");
        console.log(checkboxes);           
        var prods =[];
        var i;
        console.log('loop through checkboxes');
        for (var i = 0; i < checkboxes.length; i++){
            console.log('value of checkbox');
            if(checkboxes[i].get("v.checked") == true){
                console.log(checkboxes.length);
                console.log('lenght');
                var id = checkboxes[i].get("v.name");
                prods.push({'sobjectType':'Eval_Unit_Details__c','Id': id,
                            Eval_Quote__c : cmp.get("v.quoteid")});
                console.log(prods);
                console.log('prods');
            } 
        }
        var action = cmp.get("c.updateUnits");
        console.log(cmp.get("v.quoteid"));
        console.log('quote id for units');
        console.log('check units');
        console.log(prods);
        helper.tablehide(cmp,event,helper);
        action.setParams({"units":  prods,
                          "quoteId" : cmp.get("v.quoteid")
                         });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                console.log('units update succesful');
                helper.spinner(cmp, event, helper);
                helper.flow(cmp,event,helper);    
            }else{
                helper.spinner(cmp, event, helper);
                alert('There was an error with the eval units, please notify admint');
                console.log(rslt.getError()); 
            }
        });
        $A.enqueueAction(action); 
    },
    completed : function(cmp,event,helper){
            $A.get("e.force:closeQuickAction").fire();
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": "The eval quote has been created and email will be sent out shortly.",
                "type" : "success"
            });
            toastEvent.fire();
            $A.get('e.force:refreshView').fire();
    }
    
})