({
    myAction : function(component, event, helper) {
        
    },
    getPartners : function(cmp, event, helper) {
        var recid = cmp.get("v.recordId");
        console.log('recid = '+recid);
        var action = cmp.get("c.getOppLInes");
        action.setParams({
            "oppid":cmp.get("v.recordId")
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                var partsreturned = resp.getReturnValue();
                cmp.set("v.partners",resp.getReturnValue());
                console.log('partners gotten');
                console.log(partsreturned);
                
            }
            else{
                console.log(resp.getError());
                alert('There was an error, please notify admin');
            }
        });
        
        $A.enqueueAction(action);
    },
    selectedNext : function(cmp, event, helper) {
        var checkbox = cmp.find("DependentCheckboxpart");
        var checkboxes = [];
        if(checkbox.length == undefined){
           checkboxes.push(checkbox); 
        }else{            
            checkboxes = checkbox;
        }
        
        console.log('checkboxes');
        console.log(checkboxes.length);
        var partners =[];
        var i;
        for (var i = 0; i < checkboxes.length; i++){
            if(checkboxes[i].get("v.checked")==true){
                var id = checkboxes[i].get("v.name");
                var con = checkboxes[i].get("v.value");
                partners.push({'sobjectType':'Opportunity_Partner__c','Id': id,
                               'Reseller_Contact__c' : con}); 
            } 
        }
        cmp.set("v.selpartners",partners);
        console.log('partners selected');
        console.log(partners[0]);
        var navigate = cmp.get('v.navigateFlow');        
        navigate("NEXT");
        /* now that we got selected products, we should be able to pass to flow
          and have flow then send email to those reseller contacts. 
        */
    },
    validationCheck : function(cmp,event,helper){
        //console.log('validatin check running');
        var validation = false;
        var checkbox = cmp.find("DependentCheckboxpart");
        var checkboxes = [];
        if(checkbox.length == undefined){
           checkboxes.push(checkbox); 
        }else{            
            checkboxes = checkbox;
        }
        //above code ensures that all returned values are in an array
        //regardless if one or multiple values
        
        
        var i;
        for (var i = 0; i < checkboxes.length; i++){
            console.log(checkboxes[i].get("v.checked")+ 'is it checked?');
            if(checkboxes[i].get("v.checked")==true){
                validation = true;
            } 
        }
        console.log('validation '+validation);
        if(validation == true){
            cmp.set("v.disabled",false);
        }else{
            cmp.set("v.disabled",true);
        }
    }
    
})