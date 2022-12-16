({
	myAction : function(component, event, helper) {
		
	},
    showOpp : function(cmp,event,helper){
        var oppid = event.getSource().get("v.value");
        console.log('oppid ? ' +oppid);
        console.log('click modal open');
        var show = $A.get("e.c:oppBuyPLan");
        show.fire();
    },
    hideOpp : function(cmp,event,helper){
        console.log('click modal close');
        var hide = $A.get("e.c:oppBuyPlanhide");
        hide.fire();
    }
})