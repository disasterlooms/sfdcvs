({
	myAction : function(cmp, event, helper) {        
        helper.getSpas(cmp, event,helper);
        var saction = cmp.get("c.getStatus");
        saction.setCallback(this, function(data) {
        cmp.set("v.status", data.getReturnValue());
        });        
        $A.enqueueAction(saction);        
        var guser = cmp.get("c.getUser");        
        guser.setCallback(this, function(data) {
        cmp.set("v.user", data.getReturnValue());
        });        
        $A.enqueueAction(guser);      
        var industries = cmp.get("c.getIndustries");        
        industries.setCallback(this, function(data) {
        cmp.set("v.industries", data.getReturnValue());
        });        
        $A.enqueueAction(industries);       
        var family = cmp.get("c.getProdTypes");        
        family.setCallback(this, function(data) {
        cmp.set("v.families", data.getReturnValue());
        });        
        $A.enqueueAction(family);
	},
    search : function(cmp, event, helper) {
        helper.getSpas(cmp, event,helper);
	},
    clear : function(cmp, event, helper) {
        cmp.set("v.product",'');
        cmp.set("v.enduser",'');
        cmp.set("v.reseller",'');
        cmp.set("v.industry",'');
        cmp.set("v.family",'');
        cmp.set("v.spaid",'');
	},
    pupdate : function(cmp, event, helper) {
        //show the spinner. Get values from both 
        //opportunities and line items
        //update both and give results
        //once results are succesful, then remove spinner
        helper.showpinner(cmp, event,helper); 
        var opps = cmp.get("v.opportunities");
        var action = cmp.get("c.updateopps");
        action.setParams({"opps": cmp.get("v.opportunities"),
                          "product" : cmp.get("v.product")});
        action.setCallback(this, function(data) {
        var rslt = data.getState();
       		if (rslt === "SUCCESS"){
                helper.hidespinner(cmp, event,helper); 
            	helper.getSpas(cmp, event,helper);
            }else{
                alert('There were some errors on the save');
                 helper.hidespinner(cmp, event,helper); 
                helper.getSpas(cmp, event,helper);
            }
        });
        $A.enqueueAction(action);
	},
    enterkey : function(cmp,event,helper){
       if (event.keyCode === 13) {
           helper.getSpas(cmp, event,helper);
		} 
    }
})