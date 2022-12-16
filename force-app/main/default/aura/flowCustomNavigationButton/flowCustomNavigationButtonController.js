({
    init : function(cmp, event, helper) {
        // Figure out which buttons to display
        var availableActions = cmp.get('v.availableActions');
        for (var i = 0; i < availableActions.length; i++) {
            if (availableActions[i] == "PAUSE") {
                cmp.set("v.canPause", true);
            } else if (availableActions[i] == "BACK") {
                cmp.set("v.canBack", true);
            } else if (availableActions[i] == "NEXT") {
                cmp.set("v.canNext", true);
            } else if (availableActions[i] == "FINISH") {
                cmp.set("v.canFinish", true);
            }
        }
    },
    
    onButtonPressed: function(cmp, evt, helper) { 
        // check if address validation is needed
        // 
        console.log('the button press click action');
        var isEnterKey = evt.keyCode === 13;
        var finish = cmp.get("v.finish");
        if (!isEnterKey && !finish) {
            var navigate = cmp.get('v.navigateFlow');
                    navigate("NEXT");
        }else if(!isEnterKey && finish){
            var navigate = cmp.get('v.navigateFlow');
            navigate("FINISH");
        }
        
        
        
        
    },
    onCancel: function(cmp, event, helper) {
        var navigate = cmp.get('v.navigateFlow');
        navigate("BACK");
        
    }
})