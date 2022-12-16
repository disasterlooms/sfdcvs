({
    getAccessDetails:function(cmp) {
        var action = cmp.get("c.getAccessDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //cmp.set("v.flag", response.getReturnValue());
                cmp.set("v.flag", true);
                var userId = $A.get("$SObjectType.CurrentUser.Id");
                //if(userId == '005A0000000T6JG' || '005A0000002mWzC'){
                   // cmp.set("v.flag", true);
                //}
                
            }
        });
        $A.enqueueAction(action);
    }
})