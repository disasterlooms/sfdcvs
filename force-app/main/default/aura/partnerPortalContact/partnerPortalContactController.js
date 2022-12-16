({
    myAction : function(cmp, event, helper) {
        var userId = cmp.get("v.userConId");
        var conId = cmp.get("v.recordId");
        if(userId == conId){
            //console.log(userId+ ' user id');
            cmp.set("v.myContactRecord",true);
            
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/006/o"
            });
            //urlEvent.fire();
        }
        //console.log(cmp.get("v.cName")+' con name');
        
    },
    handleSelect : function(cmp,event,helper){
        var stepName = event.getParam("detail").value;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Toast from " + stepName
        });
        toastEvent.fire();
    }
})