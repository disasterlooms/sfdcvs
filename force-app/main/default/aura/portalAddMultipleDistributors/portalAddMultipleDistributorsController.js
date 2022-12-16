({
    myAction : function(cmp, event, helper) {
        var distis = cmp.get("c.getDistis");
        distis.setParams({"recid" : cmp.get("v.recordId")});
        distis.setCallback(this,function(resp){
            let state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                cmp.set("v.distis" , resp.getReturnValue()); 
                helper.hideSpinner(cmp,event,helper);
            }else{
                console.log('error gettin distributors account info');
                let ermsg = resp.getError();
                console.log(ermsg);
                ermsg = ermsg[0].message;
                helper.hideSpinner(cmp,event,helper);
                cmp.set("v.errMsg",'There was an error messgae. Please send support ticket with message. '+ermsg);
                console.log(ermsg[0].message);
            }            
        });
        $A.enqueueAction(distis);        
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
        helper.showSpinner(cmp,event,helper);
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