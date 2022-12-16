({
    acctvip : function(cmp, event, helper) {
        var acct = cmp.get("v.account");
        var prods = cmp.get("v.products");
        var vipprods = acct.Assets;
        console.log(vipprods);
        console.log(prods);
        //console.log(acct.VIP_Request_Type__c);
        //console.log(acct.VIP_Service_Expiration_Date__c);
        var exp = new Date(acct.VIP_Service_Expiration_Date__c);
        var today = new Date();
        if(acct.VIP_Request_Type__c == 'VIP Express Exchange' && 
           exp > today){
            console.log('its express and active');
            for (var i = 0; i < prods.length; i++){
                if(prods[i].Product2.Name != undefined &&
                   prods[i].Product2.Name != ''){         
                    var id = prods[i].Product2.Name;
                    console.log(prods[i].Product2.Name);
                    console.log('prodname');
                    if(vipprods != undefined){
                        var pos = vipprods.map(function(x) {
                            return x.Product2.Name; }).indexOf(id);
                    }
                    
                    if(pos != -1){
                        prods[i].VIP__c = true;
                    }
                }
            }
            cmp.set("v.products", prods);
            
        }
        
    },
    myAction : function(component, event, helper) {
        
    },
    
    getProducts : function(cmp, event, helper) {
        var action = cmp.get("c.getOppLines");
        action.setParams({
            "quoteid":cmp.get("v.recordId"),
            "wherestmnt" : cmp.get("v.wherestmnt"),
            "addfields" : cmp.get("v.addfields"),
            "orderstmnt" : cmp.get("v.orderstmnt")
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                cmp.set("v.products",resp.getReturnValue());
                var childComponent = cmp.find("vipact");
                var acct = childComponent.getvipinfo(cmp);
                
                if(resp.getReturnValue().length > 0){
                    cmp.set("v.showProds",true);
                }else{
                    cmp.set("v.showProds",false);
                }
            }
            else{
                alert(resp.getError());
            }
        });
        $A.enqueueAction(action);
        console.log('show account info');
        console.log(cmp.get("v.account"));
    },
    update : function(cmp, event, helper) {
        helper.toggle(cmp, event,helper);
        var prods = cmp.get("v.products");
        var action = cmp.get("c.updateOppLines");
        action.setParams({"lineitems": cmp.get("v.products"),
                          "oppid" : cmp.get("v.recordId")
                         });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                helper.toggle(cmp, event,helper);
                
                cmp.set("v.products",resp.getReturnValue());
                $A.get('e.force:refreshView').fire(); 
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Update Success",
                    "message": "The products were updated !",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
                
            }
            else{
                helper.toggle(cmp, event,helper);
                var errors = resp.getError();
                var msg = errors[0].message;
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Error",
                    "message": "There was an error saving the record. "+msg,
                    "type" : "error",
                    "error" : "error"
                });
                resultsToast.fire();
                helper.getProducts(cmp,event,helper);
                $A.get('e.force:refreshView').fire(); 
            }
        });
        
        $A.enqueueAction(action);
    },
    checkAllCheckboxes : function(cmp, event, helper) {
        var checkCmp = cmp.find("checkbox");
        var value = checkCmp.get("v.value");
        var checkboxes = cmp.find("DependentCheckbox");
        var i;
        for (var i = 0; i < checkboxes.length; i++){
            checkboxes[i].set("v.value",value);
        }
    },
    multiprods : function(cmp, event, helper) {
        console.log('multiprods');
    },
    deleteprods : function(cmp, event, helper) {
        helper.toggle(cmp, event,helper);
        var checkboxes = cmp.find("DependentCheckbox");
        var prods =[];        var i;
        for (var i = 0; i < checkboxes.length; i++){
            if(checkboxes[i].get("v.value")==true){
                var id = checkboxes[i].get("v.name");
                prods.push({'sobjectType':'QuoteLineItem','Id': id}); 
            }
        }
        cmp.set("v.delproducts",prods);  
        var action = cmp.get("c.deleteOppLines");
        action.setParams({"dlineitems": cmp.get("v.delproducts"),
                          "quoteid" : cmp.get("v.recordId")
                         });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                cmp.set("v.products",resp.getReturnValue());
                helper.toggle(cmp, event,helper);
                $A.get('e.force:refreshView').fire();
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Delete Successful",
                    "message": "The product(s) were deleted !",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
            }
            else{
                helper.toggle(cmp, event,helper);
                var errors = resp.getError();
                console.log('errors pd '+errors[0].message);
                if (errors[0] && errors[0].message) {
                    alert("Error message: " + 
                          errors[0].message);
                } else {
                    alert("Unknown error, please notify admin");
                }
                $A.get('e.force:refreshView').fire();
            }
        });
        
        $A.enqueueAction(action);
    },
    margin : function(cmp,event,helper){
        //var selectedItem = event.currentTarget;
        //var index = selectedItem.dataset.record;
        //var aprice = price.component.get("v.p");
        //console.log(index);
        //console.log(event.getSource().get("v.value"));
        var prices = cmp.find("aprice");
        var landed = cmp.find("landed");
        var disti = cmp.find("disti");
        var reseller = cmp.find("reseller");
        var i;
        var price = 1-1;
        var cost = 1-1;
        var dspiff = 1-1;
        var rspiff = 1-1;
        for (var i = 0; i < prices.length; i++){
            if(prices[i].get("v.value") != undefined){
                price = price + parseInt(prices[i].get("v.value"));
            }
            
        }
        for (var i = 0; i < landed.length; i++){
            if(landed[i].get("v.value") != undefined){
                cost = cost + parseInt(landed[i].get("v.value"));
            }
            
        }
        for (var i = 0; i < disti.length; i++){
            if(disti[i].get("v.value") != undefined){
                dspiff = dspiff + parseInt(disti[i].get("v.value"));
            }
            
        }
        for (var i = 0; i < reseller.length; i++){
            if(reseller[i].get("v.value") != undefined){
                rspiff = rspiff + parseInt(reseller[i].get("v.value"));
            }
            
        }
        console.log(price+' price');
        console.log(cost+' landed');
        console.log(dspiff+' d spiff');
        console.log(rspiff+' r spiff');
        var blended = (price-(cost+dspiff+rspiff))/price;
        if(blended > 0){
            cmp.set("v.blended",blended*100);
            console.log(' not nan');
        }else{
            
        }
        console.log(blended);
    },
    addproducts : function(cmp,event,helper){
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:OpportunityMultiProductAdd",
            componentAttributes: {
                quotes : true,
                recordId : cmp.get("v.recordId"),
                overrideaction : true
            }
        });
        evt.fire();
    },
    getSpecial : function(cmp,event,helper){
        var checkboxes = cmp.find("blendmarg");
        var len = 0;
        console.log(len);
        var price = 0;
        var cost = 0;
        var i;
        if(checkboxes.length > 1 ){
            
            
            for (var i = 0; i < checkboxes.length; i++){
                if(checkboxes[i].get("v.checked")==true){
                    len = len + 1;
                    price = price + parseInt(checkboxes[i].get("v.name"));
                    cost = cost +   parseInt(checkboxes[i].get("v.title"));
                } 
            }
            console.log(len);
            console.log(price);
            console.log(cost);
            var margin = ((price - cost)/price)*100;
            console.log(margin);
            if(margin !=  NaN && margin > 0) {
                cmp.set("v.blendedspecial", margin);
            }else{
                cmp.set("v.blendedspecial", null);
            }
            
            
        }
    },
    pmreview : function(cmp, event, helper) {
        console.log('pmreview');
        var evt = $A.get("e.force:navigateToComponent");         
        evt.setParams({
            componentDef : "c:QuoteSpecialApproval",
            componentAttributes: {
                recordId : cmp.get("v.recordId")
            }
        });
        evt.fire();
    },
    
})