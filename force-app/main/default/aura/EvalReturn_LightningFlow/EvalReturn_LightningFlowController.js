({
	myAction : function(cmp, event, helper) {
        helper.showSpinner(cmp,event,helper);
        var recid = cmp.get("v.recordId");
        console.log('recid of eval');
        console.log(recid);
        var action = cmp.get("c.getUnits");
        action.setParams({"recordId": recid
                         });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                var records = data.getReturnValue();
                for( let i = 0; i < records.length; i++){
                    console.log(records[i].Status__c);
                    if(records[i].Status__c == 'Outstanding'){
                        records[i].Write_off_Approved__c = true;
                    }else{
                        records[i].Write_off_Approved__c = false;
                    }
                    console.log(records[i].Write_off_Approved__c);
                }
                cmp.set("v.recordsReturned", records );
                console.log(data.getReturnValue());
                helper.hideSpinner(cmp,event,helper);
                  
            }else{
                alert(rslt.getError());
                helper.hideSpinner(cmp,event,helper);  
            }
        });
        $A.enqueueAction(action);
		
	},
    testItems : function(cmp,event,helper){
        var rec = cmp.get("v.recordsReturned");
        console.log('returned records checked up');
        console.log(rec);        
    },
    checkedUp : function(cmp,event,helper){
        helper.showSpinner(cmp,event,helper);  
        var rec = cmp.get("v.recordsReturned");
        var action = cmp.get("c.updateSelected");
        var quote = cmp.get("v.quoteId");
        var updateCount = cmp.get("v.updateCount");
        console.log('running count '+updateCount);
        if(updateCount > 0){
            return; 
        }else{
            updateCount = 1; 
        }
        if(quote){
            console.log('we have a quote id ');
            console.log(quote);
            
        }
        console.log('unit records for shipping');
        console.log(rec);
        
        
        action.setParams({"units" : rec
                          });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                cmp.set("v.recordsReturned",data.getReturnValue());
                console.log('returned units ');
                console.log(data.getReturnValue());
                helper.hideSpinner(cmp,event,helper);  
            }else{
                helper.hideSpinner(cmp,event,helper);
                var msg = data.getError();
                console.log('mesage error ');
                console.log(msg);
                console.log(msg[0]);
                if(msg.length>1){
                    var mssg = msg[0];

                }else{
                    mssg = msg;
                }                  
                alert('There was an error. Please report this to admin in Help Desk Ticket '+mssg);
            }
        });
        $A.enqueueAction(action);
    },
})