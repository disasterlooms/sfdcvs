({
    handleChangeWave : function(cmp,event,helper){
        //console.log('change detected');
        var params = event.getParams();
        var payload = params.payload;
        // console.log('payload');
        if(payload){
            var step = payload.step;
            // console.log('step');
            // console.log(step);
            var dataArray = payload.data;
            //console.log('data');
            // console.log(dataArray[0]);
            var data = dataArray[0];
            
            console.log('packing if log');
            if(data){
                if(data['Shipping_Instructions']){
                    cmp.set("v.shipping",data['Shipping_Instructions']);
                    cmp.set("v.packing",data['Packing_Instructions']);
                    var pack = data['Packing_Instructions'];
                    console.log('packing');
                }
                console.log('data');
                console.log(data);
                var acctid = data['AccountId'];
                console.log(acctid);
                
                var action = cmp.get("c.getContacts ");
                action.setParams({
                    "accId": acctid
                });
                action.setCallback(this, function(data) {
                    var rslt = data.getState();
                    if (rslt === "SUCCESS"){
                        cmp.set("v.cons", data.getReturnValue());
                        //cmp.set("v.loading", null);
                        console.log('cons '+data.getReturnValue());
                        //helper.spinnerhide(cmp, event,helper);    
                    }else{
                        //helper.spinnerhide(cmp, event,helper); 
                        cmp.set("v.loading", 'There was an issue with the query, please notify admin');
                    }
                });
                $A.enqueueAction(action);
                
            }
        }
        
    },
    handleSubmit : function(cmp,event,helper){
        //helper.toggle(cmp,event,helper);
        console.log('submit');
        var action = cmp.get("c.updateContacts");
        action.setParams({
            "cons": cmp.get("v.cons")
        });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                        "title": "Success!",
                        "message": "The Contact(s) Updated!",
                        "type":"success"
                    });
                    toastEvent.fire();
                    //helper.toggle(cmp,event,helper);
                
                //helper.spinnerhide(cmp, event,helper);    
            }else{
                //helper.spinnerhide(cmp, event,helper); 
                //helper.toggle(cmp,event,helper);
                alert('Sorry, there was an error, please let admin know');
            }
        });
        $A.enqueueAction(action);
    },
    handleCreate : function(cmp,event,helper){
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Contact",
            "defaultFieldValues": {
                'Marketing_Post_Sales__c' : true,
                'AccountId' : cmp.get("v.cons[0].AccountId")
            }
        });
        createRecordEvent.fire();
    },
    gettingCons : function(cmp,event,handler){
        console.log('getting cons');
        var acctid = event.getParam("acctId");
        var action = cmp.get("c.getContacts ");
                action.setParams({
                    "accId": acctid
                });
                action.setCallback(this, function(data) {
                    var rslt = data.getState();
                    if (rslt === "SUCCESS"){
                        cmp.set("v.cons", data.getReturnValue());
                        //cmp.set("v.loading", null);
                        console.log('cons '+data.getReturnValue());
                        //helper.spinnerhide(cmp, event,helper);    
                    }else{
                        //helper.spinnerhide(cmp, event,helper); 
                        cmp.set("v.loading", 'There was an issue with the query, please notify admin');
                    }
                });
                $A.enqueueAction(action);
        
    }, 
   
})