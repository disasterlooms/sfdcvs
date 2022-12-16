({
	myAction : function(component, event, helper) {
		
	},
    accounts : function(cmp, event, helper) {
        console.log('working');
        var accts = cmp.get("c.addaccts"); 
        helper.toggle(cmp,event,helper);
        accts.setCallback(this, function(data) {
            var rslt = data.getState();
            helper.toggle(cmp,event,helper);
       		if (rslt === "SUCCESS"){                
            	alert('Success');
            }else{
                alert('There were some errors on the save');
                
            }
        });        
        $A.enqueueAction(accts);        
	}, 
    contacts : function(cmp, event, helper) {
        var cons = cmp.get("c.addcontacts");
		helper.toggle(cmp,event,helper);        
        cons.setCallback(this, function(data) {
            var rslt = data.getState();
            helper.toggle(cmp,event,helper);
       		if (rslt === "SUCCESS"){
            	alert('Success');
            }else{
                alert('There were some errors on the save');
            }
        });        
        $A.enqueueAction(cons);        
	},
   
})