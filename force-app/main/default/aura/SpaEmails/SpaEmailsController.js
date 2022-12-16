({
    myAction : function(component, event, helper) {
        
    },
    selected : function(cmp, event, helper) {
        console.log('click event');
        var val =  event.getSource().get("v.value");
        console.log(val);
        var msgid = event.getSource().get("v.title");
        cmp.set("v.selectedId", msgid);
        console.log(cmp.get("v.selectedId")+' the selected id');        
    },
    getProducts : function(cmp,event,helper){
        
    },
    getMessages : function(cmp, event, helper) {
        cmp.set("v.messages",null);
        console.log('get RecordId '+cmp.get("v.recordId"));
        helper.toggle(cmp, event, helper);
        if(cmp.get("v.recordId") != undefined && cmp.get("v.recordId") != ''){           
            
            var action = cmp.get("c.getOppLines");
            action.setParams({
                "quoteid": cmp.get("v.recordId"),
                "wherestmnt" : cmp.get("v.wherestmnt"),
                "addfields" : cmp.get("v.addfields"),
                "orderstmnt" : cmp.get("v.orderstmnt")
            });
            action.setCallback(this,function(resp){
                var state = resp.getState();
                if(cmp.isValid() && state === 'SUCCESS'){
                    //pass the products to be displayed
                   
                    if(resp.getReturnValue().length == 0){
                        console.log('no emails found');
                         var spinner = cmp.find("mySpinner");
                        $A.util.addClass(spinner, "slds-hide");
                    }else{
                         cmp.set("v.messages",resp.getReturnValue());
                         cmp.set("v.nospa",false);
                         var spinner = cmp.find("mySpinner");
                        $A.util.addClass(spinner, "slds-hide");
                    }
                }
                else{
                    alert(resp.getError());
                     var spinner = cmp.find("mySpinner");
                    $A.util.addClass(spinner, "slds-hide");
                }
                
            });
            $A.enqueueAction(action);
        }
    }
})