({
    myAction : function(cmp,event,helper){        
        
    },
    handleChangeWave : function(cmp,event,helper){
        //console.log('change detected acct');
        //helper.showSpinner(cmp,event,helper);
        console.log('hide spinner conttact ifp con')
        var params = event.getParams();
        var payload = params.payload;
        cmp.set("v.oppPartners",null);
        cmp.set("v.oppContacts",null);
        
        
        if(payload){
            var step = payload.step;
            var dataArray = payload.data;
            //console.log('data');
            //console.log(dataArray[0]);
            var data = dataArray[0];
            if(data){
                //console.log('data');
                //console.log(data);
                //var spa = data['Spa_Number'];
                
                var ponumber = data['Cust_PO_Number'];
                cmp.set("v.ponumber",ponumber);
                var action = cmp.get("c.getAccountPO");
                action.setParams({
                    "ponumber": ponumber
                });
                action.setCallback(this, function(data) {
                    console.log('acct controller');
                    var rslt = data.getState();
                    if (rslt === "SUCCESS"){
                        var acc = data.getReturnValue();
                        
                        cmp.set("v.vsaorder",acc[0]);
                        cmp.set("v.shippingExists", true);
                        
                        
                        console.log('acc info returned');
                        //console.log(acc.Name);
                        //console.log( 'acct id '+acc.Id);
                        if(acc[1]){
                            console.log('acct info index 1');
                            console.log(acc[1].Name);
                            console.log(acc[1]);
                            cmp.set("v.acct",acc[1]);
                            cmp.set("v.acctId",acc[1].Id)
                            cmp.set("v.cons",acc[1].Contacts);
                            helper.hideSpinner(cmp,event,helper);
                        }else{
                             cmp.set("v.acct",null);
                             helper.hideSpinner(cmp,event,helper);
                        }
                        
                        if(acc[2]){
                             cmp.set("v.Opp",acc[2]);
                             helper.createOppResellers(cmp,event,helper);
                        }else{
                            cmp.set("v.Opp",null);
                             helper.hideSpinner(cmp,event,helper);
                        }
                        
                        //console.log('cons');
                        //console.log(acc.Contacts);
                        cmp.set("v.acctId", acc.Id);  
                    }else{
                        console.log('error');
                        cmp.set("v.shippingExists", false);
                        cmp.set("v.acctId", null);
                        cmp.set("v.acct", null);
                        helper.hideSpinner(cmp,event,helper);

                    }
                });
                
                $A.enqueueAction(action);
                
                var getOpp = cmp.get("c.getOpportunity");
                getOpp.setParams({
                    "ponumber": ponumber
                });
                getOpp.setCallback(this, function(data) {
                    console.log('get opp controller');
                    var rslt = data.getState();
                    if (rslt === "SUCCESS"){
                        var opp = data.getReturnValue();
                        //console.log( 'acct id '+acc.Id);
                        cmp.set("v.Opp",opp);
                        helper.createOppResellers(cmp,event,helper);
                        
                    }else{
                        console.log('error getting opportunity, probably no spanumber found or matched based on po number');
                        helper.hideSpinner(cmp,event,helper);
                    }
                });
                
                //$A.enqueueAction(getOpp);
                
                
                
                var poaction = cmp.get("c.getShippingInstPackingInst");
                poaction.setParams({
                    "ponumber": ponumber
                });
                poaction.setCallback(this, function(data) {
                    console.log('po to shipping controller');
                    var rslt = data.getState();
                    if (rslt === "SUCCESS"){
                       
                        var shipping = data.getReturnValue();
                        console.log('valid ship ins' + shipping );
                        //cmp.set("v.shipping",shipping);
                        
                        
                        cmp.set("v.vsaorder",shipping);
                        cmp.set("v.shippingExists", true);
                    }else{
                        console.log('error getting shipping info');
                        cmp.set("v.shippingExists", false);
                    }
                });
                
                //$A.enqueueAction(poaction);
                
            }
        }
        
    },
    newAccount : function(cmp,event,handler){
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Account",
            "defaultFieldValues": {
                'Name' : cmp.get("v.acctname") ,
                'BillingState' : cmp.get("v.bstate"),
                'Account_Type__c' : 'End User',
                'Industry' : 'Education'
            }
        });
        createRecordEvent.fire();
    },
    editOpp : function(cmp,event,handler){
        var accid = cmp.get("v.acctId");
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": accid
        });
        editRecordEvent.fire();
    },
    openOpp : function(cmp,event,handler){
        var baseURL = 'https://viewsonic.lightning.force.com/';
        var oppid = cmp.get("v.acctId");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": baseURL+oppid 
        });
        //urlEvent.fire();
        window.open('/' + oppid);  
        
    },
    handleLoad : function(cmp,event,helper){
        
    }, 
})