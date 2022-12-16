({
    getProducts : function(cmp, event, helper) {
        //set admin id for testing
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        if(userId == '005A0000000T6JG'){
            cmp.set("v.isAdmin", true);
            console.log('admin true');
        }else{
             console.log('admin false');
        }
		
        var action = cmp.get("c.getOppLInes");
        action.setParams({
            "oppid":cmp.get("v.recordId")
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                cmp.set("v.products",resp.getReturnValue());
            }
            else{
                alert(resp.getError());
            }
        });
        
        $A.enqueueAction(action);
        var saction = cmp.get("c.getStatus");
        saction.setCallback(this, function(data) {
            cmp.set("v.status", data.getReturnValue());
        });
        
        $A.enqueueAction(saction);
    },
    update : function(cmp, event, helper) {
        helper.toggle(cmp, event,helper);
        var prods = cmp.get("v.products");
        console.log('prods');
        console.log(prods);
        var action = cmp.get("c.updateOppLines");
        action.setParams({"lineitems": cmp.get("v.products"),
                          "oppid" : cmp.get("v.recordId")
                         });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                helper.toggle(cmp, event,helper);
                
                cmp.set("v.products",resp.getReturnValue());
                $A.get('e.force:refreshView').fire(); 
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Update Success",
                    "message": "The products were updated !",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
                
            }
            else{
                helper.toggle(cmp, event,helper);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Error",
                    "message": "There was an error saving the record. "+JSON.stringify(state.error),
                    "type" : "error",
                    "error" : "error"
                });
                resultsToast.fire();
                helper.getProducts(cmp,event,helper);
                $A.get('e.force:refreshView').fire(); 
            }
        });
        
        $A.enqueueAction(action);
    },
    checkAllCheckboxes : function(cmp, event, helper) {
        var checkCmp = cmp.find("checkbox");
        var value = checkCmp.get("v.value");
        var checkboxes = cmp.find("DependentCheckbox");
        var i;
        for (var i = 0; i < checkboxes.length; i++){
            checkboxes[i].set("v.value",value);
        }
    },
    deleteprods : function(cmp, event, helper) {
        helper.toggle(cmp, event,helper);
        var checkboxes = cmp.find("DependentCheckbox");
        var prods =[];        var i;
        for (var i = 0; i < checkboxes.length; i++){
            if(checkboxes[i].get("v.value")==true){
                var id = checkboxes[i].get("v.name");
                prods.push({'sobjectType':'OpportunityLineItem','Id': id}); 
            }
        }
        cmp.set("v.delproducts",prods);  
        var action = cmp.get("c.deleteOppLines");
        action.setParams({"dlineitems": cmp.get("v.delproducts"),
                          "oppid" : cmp.get("v.recordId")
                         });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                cmp.set("v.products",resp.getReturnValue());
                helper.toggle(cmp, event,helper);
                $A.get('e.force:refreshView').fire();
            }
            else{
                helper.toggle(cmp, event,helper);
                alert('Problem saving contact, error: ' + 
                            JSON.stringify(saveResult.error));
                $A.get('e.force:refreshView').fire();
            }
        });
        
        $A.enqueueAction(action);
    },
    viewschedule : function(cmp,event,helper){
        var prodid = event.getSource().get("v.name");
        console.log('prodid '+prodid);
        var relatedListEvent = $A.get("e.force:navigateToRelatedList");
        relatedListEvent.setParams({
            "relatedListId": "OpportunityLineItemSchedules",
            "parentRecordId": prodid
        });
        relatedListEvent.fire();
        
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": prodid,
            "slideDevName": "related"
        });
        //navEvt.fire();
        
    }
})