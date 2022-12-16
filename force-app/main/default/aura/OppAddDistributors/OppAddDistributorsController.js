({
    myAction : function(cmp, event, helper) {
        helper.toggleClass(cmp,'backdrop','slds-backdrop--');
        helper.toggleClass(cmp,'modaldialog','slds-fade-in-');
        var distis = cmp.get("c.getDistis");
        distis.setParams({"recid" : cmp.get("v.recordId")});
        distis.setCallback(this,function(resp){
            let state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                cmp.set("v.distis" , resp.getReturnValue()); 
            }else{
                console.log('error gettin spa account info');
                let ermsg = resp.getError();
                ermsg = ermsg[0].message;
                cmp.set("v.errMsg",'There was an error messgae. Please send support ticket with message. '+ermsg);
                console.log(resp.getError());
            }            
        });
        $A.enqueueAction(distis);        
    },
    save : function(cmp,event,helper){
        helper.toggle(cmp, event,helper);
        var btn = event.getSource();
        btn.set("v.disabled",true);
        console.log('adding');
        var oppid = cmp.get("v.recordId");
        var checkboxes = cmp.find("DependentCheckboxpart");
        var parts =[];        var i;
        for (var i = 0; i < checkboxes.length; i++){
            //console.log('values');
            //console.log(checkboxes[i].get("v.value"));
            console.log(checkboxes[i].get("v.checked"));
            if(checkboxes[i].get("v.checked")==true){
                var id = checkboxes[i].get("v.name");
                parts.push({'sobjectType':'Opportunity_Partner__c','Partner_Account__c': id,
                            'Opportunity__c' : oppid,
                            'Partner_Type__c'  : 'Distributor'}); 
            } 
        }
        if(parts.length == 0){
            helper.toggle(cmp, event,helper);
            btn.set("v.disabled",false);
            alert('You must add a distributor. If this is a direct deal, you will have to create a new opportunity and use channel pricing field to set as direct. Let admin know to delete this opportunity.');
        }else{
            //console.log('cool');
            //console.log(parts);
            var insert = cmp.get("c.addDistis");
            insert.setParams({'distis' : parts});
            insert.setCallback(this, function(data){
                var state = data.getState();
                if(state === 'SUCCESS'){
                    $A.get('e.force:refreshView').fire();
                    //pass the products to be displayed
                    //helper.toggle(cmp, event,helper);
                }
                else{
                    console.error(data.getError());                    
                    let errors = data.getError();
                    var message = errors;
                    //let message = 'Unknown error'; // Default error message
                    // Retrieve the error message sent by the server
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        message = errors[0].message;
                    }
                    alert('There was an error: '+ message);
                    console.error('err mesage '+message);
                    helper.toggle(cmp, event,helper);
                    btn.set("v.disabled",false);
                }
            });
            $A.enqueueAction(insert);
            
        }
        console.log(parts);
    },
    account : function(cmp,event,helper,id){
        
        console.log('acctid '+acctid);
        var selected  = [];
        var current = cmp.get("v.selected");
        selected.push(current,'test account');
        cmp.set("v.selected",selected);
        var updated =  cmp.get("v.selected");              
        console.log(updated);
    },
    saveToFlow : function(cmp,event,helper){
        helper.toggle(cmp, event,helper);
        var btn = event.getSource();
        btn.set("v.disabled",true);
        console.log('adding save to flow');
        var distiIds = cmp.get("v.distiIdsSelected");
        var distiNames = cmp.get("v.distiNamesSelected");
        
        var checkboxes = cmp.find("DependentCheckboxpart");
        var i;
        for (var i = 0; i < checkboxes.length; i++){
            //console.log('values');
            //console.log(checkboxes[i].get("v.value"));
            console.log(checkboxes[i].get("v.checked"));
            if(checkboxes[i].get("v.checked")==true){
                var id = checkboxes[i].get("v.name");
                var name = checkboxes[i].get("v.label");
                distiIds = distiIds+id+',';
                distiNames = distiNames+name+',';                
            } 
        }
        
        console.log('ids and then names');
        console.log(distiIds);
        console.log(distiNames);
        cmp.set("v.distiIdsSelected",distiIds);
        cmp.set("v.distiNamesSelected",distiNames);
        var navigate = cmp.get('v.navigateFlow');
        navigate("NEXT");
    },
    prevFlow : function(cmp,event,helper){
        var navigate = cmp.get('v.navigateFlow');
        navigate("BACK");
    }
})