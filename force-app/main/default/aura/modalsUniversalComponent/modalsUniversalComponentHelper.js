({
	 hideModal : function(cmp,event,helper) {
		var cmpTarget = cmp.find('modaldialog');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpTarget, 'slds-fade-in-hide');
        console.log('hide');
	},

	showModal : function(cmp,event,helper) { 
		var cmpTarget = cmp.find('modaldialog');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-hide');
        console.log('show');
	}, 
    updateSet : function(cmp,event,helper){
        var action = cmp.get("c.updateSetting");
        
        action.setParams({"mset": cmp.get("v.modalSet"),
                          "action" : 'hideit',
                          "remove" : cmp.get("v.removeModal")
                         });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
       		if (rslt === "SUCCESS"){ 
                console.log('the data sent back from server on dismiss');
                console.log(data.getReturnValue());
        		//cmp.set("v.modalSet", data.getReturnValue());
                //helper.showModal(cmp,event,helper);
                console.log('it worked ! the modal should be gone and updated');
            }else{
            }
        }); 
        $A.enqueueAction(action);
    },
    setCmpContent : function(cmp,event,helper){
        console.log('set cmp content');
        //Get the component name and the single attribute name
        //and single attribute value and set in properties/object and put in 
        //dynamic component. Easier to use a single attribute as most needs will be 
        //met. if we need to have multiple attributes then will need to create a related list
        //and pull as an array and loop through the array and add dynamically. Since the need
        //is not there yet, decided to go this route as the need may never arise.
        //
        var custCmp = cmp.get("v.modalSet.Modal__r.Component_Name__c");
        var cmpAttr = cmp.get("v.modalSet.Modal__r.Component_Attributes__c");
        var cmpValue = cmp.get("v.modalSet.Modal__r.Component_Attribute_Value__c");
        var dismissDelay = cmp.get("v.modalSet.Modal__r.DelayDismissal__c");
        var cmpAttributes = {};
        cmpAttributes[cmpAttr] = cmpValue;
        console.log('attributes');
        console.log(cmpAttributes);
        $A.createComponent(custCmp, cmpAttributes,
           function(content, status) {
               //content.set("v."+cmpAttr2,cmpAttr );
               //var cmpchk = content.get("v."+cmpAttr2);
               console.log('creating contat');
               //console.log(cmpchk);
               if (status === "SUCCESS") {
                   cmp.set("v.cmpCustom", content);
                   console.log('setting contemnt');
                   setTimeout(function(){
                       cmp.set("v.disabled",false); 
                   }, dismissDelay);
                   
                   
               }else{
                   console.log('tehre was an error creating cmp');
               }                               
           });
    }
})