({
    myAction : function(cmp, event, helper) {
        helper.showSpinner(cmp,event,helper);
        var recid = cmp.get("v.recordId");
        console.log('recid of eval');
        console.log(recid);
        var action = cmp.get("c.getUnits");
        action.setParams({"recordId": recid
                         });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                cmp.set("v.recordsReturned", data.getReturnValue());
                console.log(data.getReturnValue());
                helper.hideSpinner(cmp,event,helper);  
            }else{
                alert(rslt.getError());
                helper.hideSpinner(cmp,event,helper);  
            }
        });
        $A.enqueueAction(action);
        
    },
    testItems : function(cmp,event,helper){
        var rec = cmp.get("v.recordsReturned");
        console.log('returned records checked up');
        console.log(rec);        
    },
    checkedUp : function(cmp,event,helper){
        helper.showSpinner(cmp,event,helper);
        var theIndx =  event.getSource().get("v.name");
        var val =  event.getSource().get("v.checked");
        console.log('index is '+theIndx);
        console.log('value is '+val);  
        if(val == true){
            cmp.set("v.recordsReturned["+theIndx+"].Eval_Quote__c", cmp.get("v.quoteId"));
            
        }else{
            cmp.set("v.recordsReturned["+theIndx+"].Eval_Quote__c", null);
        } 
        
        helper.hideSpinner(cmp,event,helper);
    },
    saveSelections : function(cmp,event,helper){
         var rec = cmp.get("v.recordsReturned");
        var action = cmp.get("c.updateSelected");
        action.setParams({"units" : rec
                         });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                //helper.hideSpinner(cmp,event,helper);
                var navigate = cmp.get('v.navigateFlow');        
                navigate("NEXT");
            }else{
                helper.hideSpinner(cmp,event,helper);  
                alert(rslt.getError()); 
            }
        });
        $A.enqueueAction(action);
        
        
        
    },
})