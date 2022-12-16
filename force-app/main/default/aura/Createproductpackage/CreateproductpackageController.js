({
    myAction : function(component, event, helper) {
        
    },
    step2 : function(cmp,event,helper){
        var stp1 = cmp.get("v.step1");
        if(stp1 == true){
            cmp.set("v.step2",true);
        }else{
            cmp.set("v.step2",true);
        }
        
    },
    childSaved : function(cmp,event,helper){
       console.log('move to record' +cmp.get("v.pid"));
       var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": cmp.get("v.pid")
        });
        navEvt.fire();
    }
})