({
	getopps : function(cmp, event, helper) {
        //helper.toggle(cmp,event,helper);   
        var action = cmp.get("c.getPipe");
        action.setParams({"recid": cmp.get("v.recordId"),
                          "oppfields": cmp.get("v.oppfields"),
                          "prodfields": cmp.get("v.prodfields"),
                          "clause" : ""}); 
        action.setCallback(this, function(data) {
        cmp.set("v.opportunities", data.getReturnValue());
            var rslt = data.getState();
       		if (rslt === "SUCCESS"){
                var oppslist = data.getReturnValue();
                console.log(oppslist.length);
                if(oppslist == 0){
                    cmp.set("v.loading", 'No Related Opportunities found');
                }else{
                    cmp.set("v.loading", null);                    
                }
                
            }else{
                cmp.set("v.loading", 'There was an error in retrieving records. Admin has been notified'); 
            }
                  
        });
        $A.enqueueAction(action);
	},
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinneroppsrec");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})