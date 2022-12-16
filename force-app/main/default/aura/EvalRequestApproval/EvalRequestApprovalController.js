({
    myAction : function(cmp, event, helper) {
        //$A.get("e.force:refreshView").fire();
       
        helper.showSpinner(cmp,event,helper);
        
        var geteval = cmp.get("c.getRelatedRecords");
        geteval.setParams({"recid" : cmp.get("v.recordId")});
        console.log('eval id '+cmp.get("v.recordId"));
        geteval.setCallback(this, function(data) {
            var state = data.getState();
            if (state === "SUCCESS") {
                cmp.set("v.eval", data.getReturnValue()[0]);
                cmp.set("v.evalRequest", data.getReturnValue()[0]);            
                if(data.getReturnValue()[0].Eval_Type__c != 'ViewSonic Sales Rep Eval'){
                    console.log('Not a sales Rep success...')
                    cmp.set("v.billCon", data.getReturnValue()[1]);
                    cmp.set("v.shipCon", data.getReturnValue()[2]);
                    cmp.set("v.opp", data.getReturnValue()[3]);
                    if(data.getReturnValue()[1].Account.Type == 'End User'){
                        cmp.set("v.bacct",false);
                    }
                    if(data.getReturnValue()[1].Name){
                        console.log('got an bill acct');     
                        cmp.set("v.billinfo",true);
                    }
                    if(data.getReturnValue()[2].Name){
                        console.log('got an ship acct');     
                        cmp.set("v.shipinfo",true);
                    }
                    console.log(data.getReturnValue()[2].Name);
                    console.log('returned data');
                    helper.getBilling(cmp,event,helper);
                    helper.getShipping(cmp,event,helper);
                }else{
                    console.log('Sales Rep Eval... success');
                    cmp.set("v.salesRepEval",true);
                    cmp.set("v.userData", data.getReturnValue()[1]);
                }    
                console.log('Eval Data ');
                console.log(data.getReturnValue());
                helper.hideSpinner(cmp,event,helper);
            }else{
                var errors = response.getError();
                console.log('error on approval');
                console.log(errors);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
                
            
        });        
        $A.enqueueAction(geteval);
        console.log('sale rep status '+cmp.get("v.salesRepEval"));
    },
    cancel : function(cmp,event,helper){
        var navigate = cmp.get('v.navigateFlow');
        navigate('BACK');
        console.log('previous');
        
    },
    save : function(cmp, event, helper) {
        console.log('run the apex class approval');
        helper.showSpinner(cmp,event,helper);
        cmp.set("v.evalRequest.Send_for_Approval__c",true);
        var approval = cmp.get("c.getEval");
        approval.setParams({"eval" : cmp.get("v.evalRequest")});
        approval.setCallback(this, function(data) {
            var state = data.getState();
            console.log('running the approval apex class');
            if(cmp.isValid() && state === 'SUCCESS'){      
                console.log('Success calleback approval classs');          
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Submitted",
                    "message": "The record was submitted to your manager.",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
                $A.get('e.force:refreshView').fire();  
                console.log('success on submision');
                var cls = $A.get("e.force:closeQuickAction");
                helper.hideSpinner(cmp,event,helper);
                try{
                    cls.fire();
                }catch(err){
                    console.log('close action error');
                }
                try{
                    var navigate = cmp.get('v.navigateFlow');
                    navigate('FINISH');
                    console.log('finish');
                }catch(err){
                    console.log('finish error');
                }
                
                
            }
            else{ 
                console.log('error on submission');               
                helper.hideSpinner(cmp,event,helper);
                var errors = data.getError();               
                console.log(errors);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                try{
                    var navigate = cmp.get('v.navigateFlow');
                    navigate('FINISH');
                    console.log('finish');
                }catch(err){
                    console.log('there is not a flow');
                }
                alert('there was an error. Admin was notified.');
            }
        });        
        $A.enqueueAction(approval);
       
    }
    
})