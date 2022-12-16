({
    saveQuote : function(component, event, helper) { 
        
        helper.updateQoute(component);
        //component.find("theStaticModal").openModal();
        // Find the component whose aura:id is "flowData"
        /* var flow = component.find("flowData"); 
        var inputVariables = [ { name : "CurrentQuoteID", 
                                type : "SObject",
                                value : component.get("v.recordId")
                               } ];   
       //In that component, start your flow. Reference the flow's Unique Name 
              flow.startFlow("Update_SPA_to_Bid_Registered", inputVariables );	*/
    },
    //spinner hide
    hideSpinner : function (component, event, helper) {
        component.set("v.Spinner", false);
    },
    //spinner show
    showSpinner : function (component, event, helper) {
        component.set("v.Spinner", true); 
    },
    handleSubmit: function(cmp, event, helper) {
        cmp.set("v.disabled",true);
        //event.preventDefault();
        
        //var fields = event.getParam('fields');
        
        //cmp.find('brrecord').submit(fields);
    },
    handleSuccess: function(cmp, event) {
        //var updatedRecord = JSON.parse(JSON.stringify(event.getParams()));
        //console.log('onsuccess: ', updatedRecord.id);
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "BR Submitted",
            "message": "Request was sent to bid desk",
            "type" : "success",
            "key" : "approval"
        });
        resultsToast.fire();
        var navEvt = $A.get("e.force:navigateToSObject");
        console.log('oppid');
        console.log(cmp.get("v.recordId"));
        navEvt.setParams({
            "recordId": cmp.get("v.recordId")
        });
        navEvt.fire();
        
    },
    handleLoad : function(cmp, event, helper) {
        //console.log('oppid');
        //console.log(cmp.get("v.oppid"));
    },
    validation : function(cmp, event, helper) {
        var bus = cmp.get("v.bus");
        var eu = cmp.get("v.eu");
        var work = cmp.get("v.work");
        var meet = cmp.get("v.meet");
        var rep  = cmp.get("v.rep");
        var scope = cmp.get("v.scope");
        
        if(bus == undefined || bus == '' ||
           eu == undefined || eu == '' ||
           work == undefined || work == '' ||
           meet == undefined || meet == '' ||
           rep == undefined || rep == '' ||
           scope == undefined || scope == ''){
            cmp.set("v.disabled",true);
        }else{
            cmp.set("v.disabled",false);
        }
        
    },
    handleUploadFinished : function(cmp, event, helper){
    }
})