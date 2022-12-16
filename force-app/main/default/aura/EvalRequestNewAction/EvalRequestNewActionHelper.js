({
	evalTransfer : function(cmp, event, helper,type){
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        var action = cmp.get("c.getEval");
        let tshow = false;
        if(cmp.get("v.trade") == true){
            tshow = true;
        }
        action.setParams({"recid": cmp.get("v.evalId")
                       });
        action.setCallback(this, function(data) {
            var state = data.getState();
            if(cmp.isValid() && state === 'SUCCESS'){      
                let evalrequest = data.getReturnValue();
                console.log(data.getReturnValue());
                console.log('getting transfered eval info');
                console.log(evalrequest);
                var ship = 'Transfer Eval from Previous Order';
                var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    "entityApiName": "Eval_Request__c",
                    "defaultFieldValues": {
                        "Eval_Type__c" : type,
                        "Sales_Rep_Shipping__c" : userId ,
                        "Sales_Rep_Billing__c" : userId,
                        "Trade_Show__c" : tshow,
                        "Eval_Transfered_From__c" : cmp.get("v.evalId"),
                        "Transfer_Request__c" : cmp.get("v.transferEval"),
                        "Ship_Method__c" : ship,
                        "Product_Name__c" : evalrequest.Product_Name__c ,
                        "Product_Name_2__c" : evalrequest.Product_Name_2__c ,
                        "Product_Name_3__c" : evalrequest.Product_Name_3__c ,
                        "Product_Name_4__c" : evalrequest.Product_Name_4__c ,
                        "Product_Name_5__c" : evalrequest.Product_Name_5__c ,
                        "Quantity__c" : evalrequest.Quantity__c ,
                        "Quantity_2__c" : evalrequest.Quantity_2__c ,
                        "Quantity_3__c" : evalrequest.Quantity_3__c ,
                        "Quantity_4__c" : evalrequest.Quantity_4__c ,
                        "Quantity_5__c" : evalrequest.Quantity_5__c 
                    }
                });
            createRecordEvent.fire();
        }else{
            alert('There was an error, please notify admin ');
        }
        });
        $A.enqueueAction(action);
        
        
    },
    neweval : function(cmp, event, helper,type) {
        //set contactid of user
        if(cmp.get("v.transferEval")){
            ship = 'Transfer Eval from Previous Order';
            helper.evalTransfer(cmp,event,helper,type);
            return;
        }
        let tshow = false;
        if(cmp.get("v.trade") == true){
            tshow = true;
        }
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log('user id '+userId);
        var createRecordEvent = $A.get("e.force:createRecord");
        var ship = '';
        
        createRecordEvent.setParams({
            "entityApiName": "Eval_Request__c",
            "defaultFieldValues": {
                "Eval_Type__c" : type,
                "Sales_Rep_Shipping__c" : userId ,
                "Sales_Rep_Billing__c" : userId,
                "Trade_Show__c" : tshow,
                "Eval_Transfered_From__c" : cmp.get("v.evalId"),
                "Transfer_Request__c" : cmp.get("v.transferEval")
            }
        });
        createRecordEvent.fire();
        /*


        console.log('running helper to get user')
        var action = cmp.get("c.getUser"); 
        var recid = ''; 
        var ship = null;
        var bill = null;
        var tshow = false;
        var reason = '';
        console.log('type '+type);
        if(cmp.get("v.trade") == true){
            tshow = true;
            reason = 'trade show - See Trade Show Section'
            if(type == 'ViewSonic Sales Rep Eval'){
                recid = '0121H0000012dYk';   
                }else{
                recid = '0121H0000012dYl';
                }        
        }else{
            if(type == 'End-User/Reseller/Disty Eval'){
        	recid = '0121H000000oH55';   
            }else if(type == 'ViewSonic Sales Rep Eval'){
                recid = '0121H000000oH58';
            }else if(type == 'Reseller Demo'){
                recid = '0121H000000oH57';  
            }else {
                recid = '0121H000000oH59';  
            }            
        }
        
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            console.log('result of data ');
            console.log(rslt);
       		if (rslt === "SUCCESS"){
            	var own = data.getReturnValue();
                
                cmp.set("v.owner", data.getReturnValue());
                
                console.log(own);
                console.log('owner');
                if(type == 'ViewSonic Sales Rep Eval'){
                    bill = cmp.get("v.owner");
                    ship = cmp.get("v.owner");
                }
                //fire event to create new eval request
                var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    "entityApiName": "Eval_Request__c", 
                    "recordTypeId" : recid,
                    "defaultFieldValues": {
                        "Shipping_Contact_Name__c" : ship, 
                        "Billing_Contact_Name__c"  :  bill,
                        "Eval_Type__c" : type,
                        "Eval_Process_Stage__c" : "Awaiting Submission Request",
                        "Trade_Show__c" : tshow,
                        "Reason_for_Request__c" : reason
                    }
                });
                createRecordEvent.fire();
            }else{
                alert('Admin has been notified of an error. Please Contact Admin for Assistance');
                 var message = 'Unknown error';
                //var errors = data.getError();
                 //var message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                //if (errors && Array.isArray(errors) && errors.length > 0) {
                    //message = message+' '+errors[0].message;
                //}
                // Display the message
                console.error(message);
                
                
            }
            var reqtype2 = $A.get("e.force:closeQuickAction");
            console.log('req2');
            console.log(reqtype2);
        });
        $A.enqueueAction(action);
        */
        
	}
})