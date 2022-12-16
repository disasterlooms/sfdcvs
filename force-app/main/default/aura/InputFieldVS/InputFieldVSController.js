({
	myAction : function(cmp, event, helper) {
		$A.get("e.force:refreshView").fire();
        console.log('loaded comp input');
        cmp.find("part").reloadRecord();
	},
    refresh : function(cmp,event,helper){
         cmp.find("part").reloadRecord();
         console.log('reloading');
    }
})