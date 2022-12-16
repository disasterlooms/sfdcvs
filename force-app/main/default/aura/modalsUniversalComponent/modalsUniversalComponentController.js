({
	myAction : function(cmp, event, helper) {
        var action = cmp.get("c.getModalSetting");
        console.log('modal log');
        
        action.setParams({"modalName": cmp.get("v.modalName"),
                          "parentFields" : cmp.get("v.parentFields"),
                          "whereStatement" : cmp.get("v.whereStatement"),
                          "orderStatement" : cmp.get("v.orderStatement"),
                          "limitStatement" : cmp.get("v.limitStatement")    
                         });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
       		if (rslt === "SUCCESS"){            	
        		var retVal = data.getReturnValue();
                cmp.set("v.modalSet", retVal);
                if(retVal != null){
                    helper.showModal(cmp,event,helper);
                    if(retVal.Modal__r.useComponent__c == true &&
                        retVal.Modal__r.Component_Name__c != ''){
                        helper.setCmpContent(cmp,event,helper);
                    }else{
                        setTimeout(function(){
                       cmp.set("v.disabled",false); 
                   		}, 3000);
                    }
                    
                }
                console.log('it worked ! the modal should show unless null see below');
                console.log(retVal);
            }else{
            }
        }); 
        $A.enqueueAction(action);
		
	},
    dismiss : function(cmp,event,helper){
        console.log('dismiss');
        cmp.set("v.removeModal", true);
        helper.hideModal(cmp,event,helper);
        helper.updateSet(cmp,event,helper);
        
    },
    later : function(cmp,event,helper){
        console.log('dismiss');
        cmp.set("v.removeModal", false);
        helper.hideModal(cmp,event,helper);
        helper.updateSet(cmp,event,helper);
        
    },
    callToAction : function(cmp,event,helper){
        var url = cmp.get("v.modalSet.Modal__r.Action_URL__c");
        var clicked = cmp.get("v.modalSet.Times_Clicked__c")+ 1; 
        cmp.set("v.modalSet.Times_Clicked__c",clicked );
        console.log('action url');
        console.log(url);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
        helper.updateSet(cmp,event,helper);
    }
})