({
	myAction : function(cmp, event, helper) {
       var modal = cmp.get("v.inModal");
        console.log('dashboard');
        if(!modal){
            console.log('running get the dashid');
            helper.getReleatedId(cmp,event,helper);
        }
	}
})