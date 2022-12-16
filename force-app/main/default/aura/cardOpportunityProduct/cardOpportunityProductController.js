({
	myAction : function(component, event, helper) {
		
	},
    navFlow : function(cmp,event,helper){
        console.log('parent action running');
        var navigate = cmp.get('v.navigateFlow');        
        navigate("NEXT");
    }
})