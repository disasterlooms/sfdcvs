({
    myAction : function(component, event, helper) {
        
    },
    updatequery : function(cmp, event, helper) {
        //console.log('running event');
        var pid = event.getParam("parentid");
        //console.log(pid);
        cmp.set("v.wherestmt", ' where Product_Package__c =  \'' + pid + '\'' ); 
        
        //"where Product_Package__c = 'a080R00000098kVQAQ'"        
        //'and '+cmp.get("v.searchfield") +' like  \'%' + cmp.get("v.search")  + '%\'';
        //console.log(cmp.get("v.wherestmt"));
        //console.log(pid);
        cmp.set("v.parentid",pid);
        //console.log('the parent id to value');
        //console.log(cmp.get("v.parentid",pid));
    }
})