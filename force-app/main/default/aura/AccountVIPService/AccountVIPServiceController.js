({
    myAction : function(cmp, event, helper) {
        var records = cmp.get("c.getStatus");
        records.setParams({"recid" : cmp.get("v.recordId")});        
        records.setCallback(this,$A.getCallback( function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                console.log('get vip data '+data.getReturnValue());
                var status = data.getReturnValue().VIP_in_Approval_Process__c;
                cmp.set("v.account",data.getReturnValue());
                if(status == true){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "This is in Approval Already. If you need to change information, please recall the request from the approval section on Bottom of Account Page",
                        "type": "error"
                    });
                    toastEvent.fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    $A.get('e.force:refreshView').fire();
                }
            }else{
                 var errors = data.getError();
                 var messages = ''; 
                 //var i= ; 
                 for(var i = 0; i < errors.length; i++){
                    messages = messages +'\n\n'+ errors[i].message;
                }
                alert(' '+messages);
            }
        }));
        $A.enqueueAction(records);
        
    },
    cancel : function(cmp,event,helper){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    handleSubmit : function(cmp,event,helper){
        
        
    },
    handleSuccess : function(cmp,event,helper){
        helper.toggle(cmp,event,helper);
        var type = cmp.get("v.vip"); 
        if(type == 'Hotline Only'){
            helper.hotline(cmp,event,helper);
            /*
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": "Hotline Request has been sent to your manager for approval",
                "type": "success"
            });
            toastEvent.fire();
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
			$A.get('e.force:refreshView').fire();
          */            
        }else{
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:AccountProducts",
                componentAttributes: {
                    recordId : cmp.get("v.recordId")
                }
            });
            evt.fire();            
        }
        
    },
    handleLoad : function(cmp,event,helper){
        var vip = cmp.get("v.vip");
        var reason = cmp.get("v.reason");
        if(vip == 'Hotline Only' || vip == undefined || vip == ''){
             cmp.set("v.buttonlabel", "Save"); 
           
        }else{
           cmp.set("v.buttonlabel", "Select Products to be Approved");
        }
    },
    validate : function(cmp,event,helper){
        var vip = cmp.get("v.vip");
        var reason = cmp.get("v.reason");
        var reseller = cmp.get("v.reseller");
        console.log(vip);
        console.log(reason);
        console.log(reseller);
        if(reason != '' && vip != ''&& vip != undefined && reason != undefined && reseller != ''&& reseller != undefined){
            cmp.set("v.disabled",false);   
        }else{
            cmp.set("v.disabled",true);  
        }
        console.log(vip);
        if(vip == 'Hotline Only' || vip == undefined || vip == ''){
             cmp.set("v.buttonlabel", "Save"); 
           
        }else{
           cmp.set("v.buttonlabel", "Select Products to be Approved");
        }
        console.log(cmp.get("v.disabled"));
    }
})