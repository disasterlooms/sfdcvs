({
    handleSuccess : function(cmp, event, helper) {
        helper.hideSpinner(cmp,event,helper);
        var payload = event.getParams().response;
        console.log(payload.id);
        cmp.set("v.quoteId", payload.id);
        debugger;
        var navigate = cmp.get('v.navigateFlow');        
        navigate("NEXT");
    },
    handleSubmit : function(cmp, event, helper) {
        helper.showSpinner(cmp,event,helper);
    },
    handleError : function(cmp,event,helper){
        helper.hideSpinner(cmp,event,helper);
        
    },
    nextScreen: function(cmp, event, helper) {        
        var navigate = cmp.get('v.navigateFlow');        
        navigate("NEXT");
    },
    myAction : function(cmp,event,helper){
         helper.showSpinner(cmp,event,helper);
        
        var geteval = cmp.get("c.getRelatedRecords");
        geteval.setParams({"recid" : cmp.get("v.recordId")});
       
        geteval.setCallback(this, function(data) {
            cmp.set("v.billCon", data.getReturnValue()[1]);
            cmp.set("v.shipCon", data.getReturnValue()[2]);
            cmp.set("v.opp", data.getReturnValue()[3]);
            if(data.getReturnValue()[4]){
                 cmp.set("v.resellerConExists",true);
                 cmp.set("v.resellerCon",data.getReturnValue()[4]);
            }
           
            helper.hideSpinner(cmp,event,helper);
           
        });        
        $A.enqueueAction(geteval);
        
    },
    billCon : function(cmp,event,helper){
        //debugger;
        console.log('bilccon');
        var company = cmp.get("v.billCon.Account.Name");
        console.log(company);
        console.log(cmp.get("v.billCon"));
        
        cmp.set("v.companyName", cmp.get("v.billCon.Account.Name"));
        cmp.set("v.Billing_Contact_Phone__c", cmp.get("v.billCon.Phone"));
        cmp.set("v.Billing_Street__c", cmp.get("v.billCon.MailingStreet"));
        cmp.set("v.Billing_City__c", cmp.get("v.billCon.MailingCity"));
        cmp.set("v.Billing_State__c", cmp.get("v.billCon.MailingState"));
        cmp.set("v.Billing_Zip_Postal__c", cmp.get("v.billCon.MailingPostalCode"));
        cmp.set("v.Billing_Country__c", cmp.get("v.billCon.MailingCountry"));
        cmp.set("v.Billing_Contact_Name__c", cmp.get("v.billCon.Name"));
        cmp.set("v.Billing_Contact_Email__c", cmp.get("v.billCon.Email"));
        
    },
    shipCon : function(cmp,event,helper){
        //debugger;
         cmp.set("v.companyName", cmp.get("v.shipCon.Account.Name"));
        cmp.set("v.Billing_Contact_Phone__c", cmp.get("v.shipCon.Phone"));
        cmp.set("v.Billing_Street__c", cmp.get("v.shipCon.MailingStreet"));
        cmp.set("v.Billing_City__c", cmp.get("v.shipCon.MailingCity"));
        cmp.set("v.Billing_State__c", cmp.get("v.shipCon.MailingState"));
        cmp.set("v.Billing_Zip_Postal__c", cmp.get("v.shipCon.MailingPostalCode"));
        cmp.set("v.Billing_Country__c", cmp.get("v.shipCon.MailingCountry"));
        cmp.set("v.Billing_Contact_Name__c", cmp.get("v.shipCon.Name"));
        cmp.set("v.Billing_Contact_Email__c", cmp.get("v.shipCon.Email"));
        
    },
    
    resellerCon : function(cmp,event,helper){
        cmp.set("v.companyName", cmp.get("v.resellerCon.Account.Name"));
        cmp.set("v.Billing_Contact_Phone__c", cmp.get("v.resellerCon.Phone"));
        cmp.set("v.Billing_Street__c", cmp.get("v.resellerCon.MailingStreet"));
        cmp.set("v.Billing_City__c", cmp.get("v.resellerCon.MailingCity"));
        cmp.set("v.Billing_State__c", cmp.get("v.resellerCon.MailingState"));
        cmp.set("v.Billing_Zip_Postal__c", cmp.get("v.resellerCon.MailingPostalCode"));
        cmp.set("v.Billing_Country__c", cmp.get("v.resellerCon.MailingCountry"));
        cmp.set("v.Billing_Contact_Name__c", cmp.get("v.resellerCon.Name"));
        cmp.set("v.Billing_Contact_Email__c", cmp.get("v.resellerCon.Email"));
        
    },
    handleLoad : function(cmp,event,helper){
        
    }
    
})