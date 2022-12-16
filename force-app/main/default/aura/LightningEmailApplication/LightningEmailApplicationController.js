({
	myAction : function(cmp, event, helper) {
		console.log(cmp.get("v.people"));
        console.log('people');
        helper.relatedOpps(cmp,event,helper);
	} ,
    handleClick : function(cmp,event,helper){

        var oppid =    event.getSource().get("v.title");     
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": oppid
        });
        navEvt.fire();
    }
})