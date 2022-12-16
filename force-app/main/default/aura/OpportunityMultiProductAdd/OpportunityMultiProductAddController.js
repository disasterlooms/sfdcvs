({
	myAction : function(cmp, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": cmp.get("v.recordId")
        });
        navEvt.fire();
	},
    createProducts : function(cmp,event,helper){
        console.log('create products on opportunity mulit product add comp');
        let counter = cmp.get("v.createCounter");
        //this nxt line will check if thies create lines has allready ruan, 
        //but this is not the best fix, as the root issue 
        //is that the change method happens 2 times. and tha should be fixed. 
        //this will resolve the problem for now 6.21.2021
        if(!counter){
            return;
        }
        if(cmp.get("v.overrideaction") == true){
            helper.showSpinner(cmp,event,helper);
            console.log('override action');
            console.log(cmp.get("v.selections"));
            var quantity = cmp.get("v.quant");
            console.log(quantity);
            console.log('quantity '+quantity);         
            var records = cmp.get("c.addLines");
            if(cmp.get("v.quotes") == true){
            	records  = cmp.get("c.addQuoteLines");
            }
            console.log('Opp multi producut cmp.. run method quotes if quote true '+ cmp.get("v.quotes"));
            console.log('Record Id '+cmp.get("v.recordId") );
            console.log('Prods to add Id '+cmp.get("v.selections") );
            
            records.setParams({"recid" : cmp.get("v.recordId"),
                               "prods" : cmp.get("v.selections"),
                               "quant" : quantity});
            records.setCallback(this, function(data){
                var state = data.getState();
                if(state === 'SUCCESS'){
                    var ext = cmp.get("v.externalUser");                    
                    var mssg  = 'Update Quantity and Notes On the Pipeline Tab!!';
                    if(ext){
                        mssg = 'Your Sales Rep has been Notified';
                    }
                    helper.hideSpinner(cmp,event,helper);
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Products added",
                        "message": mssg,
                        "type" : "success",
                        "key" : "approval"
                    });
                    resultsToast.fire();
                    var navigate = cmp.get('v.navigateFlow');
                    if(navigate){
                        navigate('NEXT');

                    }else{
                        $A.get('e.force:refreshView').fire();                    
                        var cls = $A.get("e.force:closeQuickAction");
                        cls.fire();
                    }
                }
                else{
                   helper.hideSpinner(cmp,event,helper);
                    var errors = data.getError(); 
                    var msg = errors[0].message;
                            cmp.set("v.showErrors",true);
                            cmp.set("v.errorMessage",errors[0].message);
                    alert('There was an error adding these product. Please notify admin by using the utility called "AdminHelpRequest" on the bottom of the page. More Details: '+msg);
                   $A.get('e.force:refreshView').fire();
                   var cls = $A.get("e.force:closeQuickAction");
                   cls.fire();
                }
            });
            console.log('Creation Counter Method');
            if(counter){
                console.log('counter log is true');
                 cmp.set("v.createCounter",false);
                 $A.enqueueAction(records);
            }
            
        }        
        
    }
})