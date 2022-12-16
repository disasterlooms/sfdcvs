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
		
        console.log('rec id '+cmp.get("v.recordId"));
        var action = cmp.get("c.getOppLInes");
        action.setParams({
            "oppid":cmp.get("v.recordId")
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                cmp.set("v.products",resp.getReturnValue());
                if(cmp.get("v.likelyProduct") == true){
                    var checks = cmp.find("likleyCheck");
                    var i = 0;
                    for(i in checks){
                        checks[i].set("v.checked",true);
                        //console.log('check value(s)');
                        //console.log(checks[i].get("v.value"));
                    }  
                }
                
                
                
                
                //checks.set("v.checked", true);
            }
            else{
                var er = resp.getError();
                console.log(er);
                console.log(er.message);
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
         console.log('products info '+cmp.get("v.products"));
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
                var compEvent = cmp.getEvent("flowScreen");
                
                compEvent.fire();
                console.log('child triggering parent event')
                
            }
            else{
                var er = resp.getError();
                helper.toggle(cmp, event,helper);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Error",
                    "message": "There was an error saving the record. Please check to ensure that prices and quantities are not blank. The error message states: "+er[0].message,
                    "type" : "error",
                    "error" : "error"
                });
                console.log('error in updating products')
                console.log(er);
                console.log(er[0].message);
                //alert(resp.getError());
                
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
                let errors = resp.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                alert('Problem deleting product, error: ' + 
                           message);
                $A.get('e.force:refreshView').fire();
            }
        });
        
        $A.enqueueAction(action);
    },
    viewschedule : function(cmp,event,helper){
        var prodid = event.getSource().get("v.name");
        console.log('prodid '+prodid);
        
        //
        //
       var modalFooter;
       var modalBody;
   			$A.createComponents([
                ["c:ScheduleMulti",{ lineid : prodid}]
            ],
           function(components , status) {
               if (status === "SUCCESS") {
                   modalBody = components [0];
                   //modalFooter = components[1];
                   cmp.find('overlayLib1').showCustomModal({
                       header: "Update Schedule and Save",
                       body: modalBody,
                       //footer: modalFooter,
                       showCloseButton: true,
                       cssClass: "mymodal slds-modal_medium",
                       closeCallback : function() {
                       }
                   })
               }                               
           }); 
        
        
        
        
        /*
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
        */
        
    }
})