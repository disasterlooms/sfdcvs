({
	showOppmodal: function(component, event, helper) {
		//Toggle CSS styles for opening Modal
		helper.toggleClass(component,'backdrop','slds-backdrop--');
		helper.toggleClass(component,'modaldialog','slds-fade-in-');
        //var opps = event.getParam("opportunities");
        //component.set("v.opportunities", opps);
        //console.log(opps);
        helper.getOppContacts(component,event,helper);
	},
	hideModal : function(component, event, helper) {
		 //Toggle CSS styles for hiding Modal
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'modaldialog','slds-fade-in-');
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
    sendmail : function(cmp, event, helper) {
        helper.toggle(cmp, event,helper);
        var checkboxes = cmp.find("DependentCheckboxcon");
        var oppcons =[];
        var i;
        for (var i = 0; i < checkboxes.length; i++){
            if(checkboxes[i].get("v.value")==true){
                var id = checkboxes[i].get("v.name");
                oppcons.push({'sobjectType':'Contact_Role__c','Id': id}); 
            } 
        }
        cmp.set("v.conemails",oppcons);
        var action = cmp.get("c.emailCons");
        action.setParams({"oppcons": cmp.get("v.conemails")
                         });
        console.log(oppcons);
        action.setCallback(this,function(resp){
                var state = resp.getState();
                if(cmp.isValid() && state === 'SUCCESS'){
                    alert('Success! Your emails will be sent out shortly.');
                    $A.get('e.force:refreshView').fire();
                }
                else{
                    console.log(resp.getError());
                    errors = resp.getError();
                    alert('There was an error, please send this message to admin for assitance '+
                          errors[0].message);
                    $A.get('e.force:refreshView').fire();
                }
            });
            
            $A.enqueueAction(action);
    }
})