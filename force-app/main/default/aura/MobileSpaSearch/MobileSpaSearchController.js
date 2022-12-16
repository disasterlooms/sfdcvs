({
	myAction : function(cmp, event, helper) {
		console.log('pressed');	
	},
    search : function(cmp, event, helper) {
        helper.getSpas(cmp, event,helper);
	},
    keyCheck : function(cmp, event, helper){
        if (event.which == 13){
            helper.getSpas(cmp, event,helper);
            console.log('enter key');
        }    
    },
})