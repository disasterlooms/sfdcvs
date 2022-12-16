({
        myAction : function(cmp, event, helper) {
            //var myPageRef = cmp.get("v.pageReference");
            //var lid = myPageRef.olineId;
            //cmp.set("v.lineid", lid);
            
            console.log('action');
            
            var action = cmp.get("c.getmonths");
            action.setCallback(this, function(data) {
                var rslt = data.getState();
                if (rslt === "SUCCESS"){
                    cmp.set("v.months", data.getReturnValue());
                    //cmp.set("v.loading", null);
                    console.log('monts '+data.getReturnValue());
                    //helper.spinnerhide(cmp, event,helper);    
                }else{
                    //helper.spinnerhide(cmp, event,helper); 
                    cmp.set("v.loading", 'There was an issue with the query, please notify admin');
                }
            });
            $A.enqueueAction(action);
            
            var act = cmp.get("c.getSchedule");
            act.setParams({
                "lineid":cmp.get("v.lineid")
            });
            console.log(cmp.get("v.lineid"));
            act.setCallback(this, function(data) {
                var rslt = data.getState();
                if (rslt === "SUCCESS"){
                    cmp.set("v.lineitems", data.getReturnValue());
                    console.log('sucess line items')
                    //cmp.set("v.loading", null);    
                    //helper.spinnerhide(cmp, event,helper);    
                }else{
                    //helper.spinnerhide(cmp, event,helper); 
                    cmp.set("v.loading", 'There was an issue with the query, please notify admin');
                }
            });
            $A.enqueueAction(act);
            console.log('line items');
            console.log(cmp.get("v.lineitems"));
        },
        handleSubmit : function(cmp, event, helper) {
            helper.toggle(cmp,event,helper);
            var act = cmp.get("c.updateSched");
            var lines = cmp.get("v.lineitems");
            console.log(lines);
            act.setParams({
                "schd":  lines
            });
            act.setCallback(this, function(data) {
                var rslt = data.getState();
                if (rslt === "SUCCESS"){
                    console.log('sucess');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The Schedule was Updated!",
                        "type":"success"
                    });
                    toastEvent.fire();
                    helper.toggle(cmp,event,helper);
                     //helper.closeModal(cmp,event,helper);
                }else{
                     helper.toggle(cmp,event,helper);
                    //helper.spinnerhide(cmp, event,helper); 
                    //cmp.set("v.loading", 'There was an issue with the query, please notify admin');
                    console.log('error');
                     //helper.closeModal(cmp,event,helper);
                }
            });
            $A.enqueueAction(act);
           
            
        },
        handleCancel : function(cmp,event,helper){
            helper.closeModal(cmp,event,helper);
            
        },
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
                if(data){
                
                var olineid = data['OpportunityLineItemId'];
                //console.log('id '+olineid);
                cmp.set("v.lineid",olineid);
                helper.getSchdule(cmp,event,helper);
                }
                
                
                
            }
            
        }
    })