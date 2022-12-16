({
	 myAction : function(cmp, event, helper) {
        console.log('running');
        helper.getRecords(cmp, event, helper);
        
    },
    searchk : function(cmp,event,helper){
        
        console.log('para');
        console.log(cmp.get("v.search"));
        console.log(event.getParams());
        if(event.getParams().keyCode == 13){
            console.log('search');
            helper.toggle(cmp, event,helper);
            helper.getRecords(cmp,event, helper); 
        }
    },
    search : function(cmp,event,helper){
        helper.toggle(cmp, event,helper);
        console.log('search');
        console.log('para');
        console.log(cmp.get("v.search"));
        console.log(event.getParams());
        helper.getRecords(cmp, event, helper); 
    },
    refreshChild : function(cmp, event, helper) {
        console.log('running the refresh of child records');
        helper.getRecords(cmp, event, helper);
        
    }
})