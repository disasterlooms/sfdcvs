({
    getContacts : function(cmp, event, helper) {
        console.log('opp contacts');
        var action = cmp.get("c.getOppContacts");
        action.setParams({
            "oppid":cmp.get("v.recordId")
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the contacts to be displayed
                cmp.set("v.contacts",resp.getReturnValue());
            }
            else{
                alert(resp.getError());
            }
        });
        
        $A.enqueueAction(action);
    },
    checkAllCheckboxescon : function(cmp, event, helper) {
        console.log('check boxes');
        var checkCmp = cmp.find("checkboxcon");
        var value = checkCmp.get("v.value");
        console.log('value '+value);
        var checkboxes = cmp.find("DependentCheckboxcon");
        
        //if more than one record, then will loop through list
        if(typeof(checkboxes)==='object'){
            var i;
            for (var i = 0; i < checkboxes.length; i++){
                checkboxes[i].set("v.value",value);
            }
        //if there is one record, it will not be in list
        //setting up value in that case
        }else{            
            checkboxes.set("v.value",value);
        }
        
    },
    newContact : function(cmp, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "OpportunityContactRole",
             "defaultFieldValues": {
                 "OpportunityId": cmp.get("v.recordId")
             }
        });
        createRecordEvent.fire();
    },
    
    newEmail : function(cmp, event, helper) {
        console.log('nemail');
    }
    
})