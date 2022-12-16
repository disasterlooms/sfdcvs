({
    myAction : function(cmp, event, helper) {
        var quantity =  cmp.get("v.quant");
        if(quantity < 1){
            cmp.set("v.quannull", true);
        }else{
            cmp.set("v.quannull", false); 
        }
        
    },
    createProducts : function(cmp,event,helper){
        console.log('create');
        if(cmp.get("v.overrideaction") == true){
            helper.toggle(cmp,event,helper);
            console.log('override action');
            console.log(cmp.get("v.selections"));
            var quantity = cmp.get("v.quant");
            console.log(quantity);
            var records = cmp.get("c.addRecords");
            records.setParams({"recid" : cmp.get("v.recordId"),
                               "packages" : cmp.get("v.selections"),
                               "quant" : cmp.get("v.quant")});
            records.setCallback(this, function(data){
                var state = data.getState();
                if(state === 'SUCCESS'){
                    helper.toggle(cmp,event,helper);
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Products added",
                        "message": "The products were added !",
                        "type" : "success",
                        "key" : "approval"
                    });
                    resultsToast.fire();
					$A.get('e.force:refreshView').fire();                    
                    var cls = $A.get("e.force:closeQuickAction");
                    cls.fire();
                    
                }
                else{
                   helper.toggle(cmp,event,helper); 
                   alert('There was an error adding these product. Please notify admin by using the utility called "AdminHelpRequest" on the bottom of the page');
                   $A.get('e.force:refreshView').fire();
                   var cls = $A.get("e.force:closeQuickAction");
                   cls.fire();
                }
            });
            $A.enqueueAction(records);
            
        }        
        
    }
})