({
    getProducts : function(cmp, event, helper) {
        var action = cmp.get("c.getOppLInes");
        action.setParams({
            "oppid":cmp.get("v.recordId")
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                cmp.set("v.partners",resp.getReturnValue());
            }
            else{
                alert(resp.getError());
            }
        });
        
        $A.enqueueAction(action);
    },
    checkAllCheckboxes : function(cmp, event, helper) {
        var checkCmp = cmp.find("checkboxpart");
        var value = checkCmp.get("v.value");
        var checkboxes = cmp.find("DependentCheckboxpart");
        var i;
        for (var i = 0; i < checkboxes.length; i++){
            checkboxes[i].set("v.value",value);
        }
    },
    deleteparts : function(cmp, event, helper) {
        helper.toggle(cmp, event,helper);
        var checkboxes = cmp.find("DependentCheckboxpart");
        var prods =[];        var i;
        for (var i = 0; i < checkboxes.length; i++){
            if(checkboxes[i].get("v.value")==true){
                var id = checkboxes[i].get("v.name");
                prods.push({'sobjectType':'Opportunity_Partner__c','Id': id}); 
            } 
        }
        cmp.set("v.delpartners",prods);  
        var action = cmp.get("c.deleteOppLines");
        action.setParams({"dpartners": cmp.get("v.delpartners"),
                          "oppid" : cmp.get("v.recordId")
                         });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                cmp.set("v.partners",resp.getReturnValue());
                helper.toggle(cmp, event,helper);
                $A.get('e.force:refreshView').fire();
            }
            else{
                alert(resp.getError());
            }
        });
        
        $A.enqueueAction(action);
    },
    update : function(cmp, event, helper) {
        helper.toggle(cmp, event,helper);
        var prods = cmp.get("v.partners");
        var action = cmp.get("c.updatePartners");
        action.setParams({"uppartners": cmp.get("v.partners"),
                          "oppid" : cmp.get("v.recordId")
                         });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                helper.toggle(cmp, event,helper);
                $A.get('e.force:refreshView').fire();
                cmp.set("v.partners",resp.getReturnValue());
                
            }
            else{
                helper.toggle(cmp, event,helper);
                alert(resp.getError());
            }
        });
        
        $A.enqueueAction(action);
    },
    refreshinput : function(cmp,event,handler){
        console.log('changed cool');
        cmp.find("pcontact").reloadRecord();
        
    },
    editpartner : function(cmp,event,handler){
        var partid = event.getSource().get("v.value");
        console.log('edit');
        console.log(partid);
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": partid,
            "Quote__c" : cmp.get("{!v.simpleRecord.Primary_Quote__c}")
        });
        editRecordEvent.fire();
        
    }
    
})