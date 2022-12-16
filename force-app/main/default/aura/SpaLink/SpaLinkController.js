({
    handleChangeWave : function(cmp,event,helper){
    
        var params = event.getParams();
        var payload = params.payload;
        console.log('payload');
        console.log(payload);
        if(payload){
            var step = payload.step;
            console.log('ste p');
            console.log(step);
            
            console.log('payloaddata');
            console.log( payload.data);
            var dataArray = payload.data;
            console.log('data');
            console.log(dataArray[0]);
            console.log(dataArray[1]);
            console.log('d array 1 and 2');
            
            var data = dataArray[0];
            if(data){
                
                var oppid = data['OpportunityLineItemId.OpportunityId'];
                console.log('oppid '+oppid);
                cmp.set("v.recordId",oppid);
                helper.getrelatedspa(cmp,event);
            }
        }
        
    
    },
    
    myAction : function(cmp, event, helper) {
        helper.getrelatedspa(cmp,event);
    },
    spaupdate : function(cmp, event, helper) {
        //show the spinner. Get values from both 
        //opportunities and line items
        //update both and give results
        //once results are succesful, then remove spinner
        //add spinner event and then fire after completion of update
        var spas = $A.get("e.c:spinner");
        var opps = cmp.get("v.quotes");
        var action = cmp.find('spasupdate').get('c.updateopps');
        var old = cmp.get("v.oldquotes");
        //var newquotes = cmp.get("v.quotes");
        console.log(old);
        console.log(opps);
        
        action.setParams({"newspas": opps,
                          "oldspas": old
                         });
        action.setCallback(this,$A.getCallback( function(data) {
            $A.get("e.c:spinner").fire();
            var rslt = data.getState();
       		if (rslt === "SUCCESS"){
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Resubmission Request Submitted",
                    "message": "Request was sent to bid desk",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
                $A.get('e.force:refreshView').fire();
            }else{
                 var errors = data.getError();
                 var messages = ''; 
                 //var i= ; 
                 for(var i = 0; i < errors.length; i++){
                    messages = messages +'\n\n'+ errors[i].message;
                }
                alert(' '+messages);
            }
        }));
        $A.enqueueAction(action);
	},
    createSpa : function (cmp, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        var opp = cmp.get("v.opportunity");
        //checking country of user to determine correct record type
        //so the correct pricebook options show
        
        //set variables for country and channel pricing
        var recid = '';
        var country = cmp.get("v.user.Country");
        if(country == 'United States'){
            recid= '0121H0000012dYT';
            country = 'United States'
        }else if(country == 'Canada'){
            recid= '0121H0000012dYR';
            country = 'Canada'
        }else{
            recid= '0121H0000012dYS';
            country = 'Latin America'
        }
        //need to set record types based on user profile
        //so the correct pricebooks show
        createRecordEvent.setParams({
            "entityApiName": "Opportunity", 
            "recordTypeId" : recid,
            "defaultFieldValues": {
                'StageName' : 'Price Request',
                'End_User_Lookup_Account__c' : opp.AccountId,
                'AccountId' : opp.AccountId,
                'Name' : 'SPA '+opp.Account.Name,
                'Partner_Account_Search__c' : opp.Partner_Account_Search__c,
                'ResellerContact__c' : opp.ResellerContact__c,
                'End_User_Contact__c' : opp.End_User_Contact__c,
                'Trade_Show_or_Marketing_Campaign__c' : opp.Trade_Show_or_Marketing_Campaign__c,
                'CloseDate' : opp.CloseDate,
                'Opportunity_Notes__c' : opp.Opportunity_Notes__c,
                'SpaCreateFOpp__c' : opp.Id,
                'Country__c' : country
            }
        });
        createRecordEvent.fire();
  },
    bidRegSpa : function (cmp, event, helper){
        var quoteid = event.getSource().get("v.value");
        console.log(quoteid+' quoteid');
        var evt = $A.get("e.force:navigateToComponent");
        console.log('compnav test');
        console.log(evt);
        evt.setParams({
            componentDef: "c:SpaBidReg",
            componentAttributes: {
                    quoteid : quoteid
                }
        });
       
        //evt.fire();
        //
        //
        //
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": quoteid,
                "slideDevName": "detail"
            });
            navEvt.fire();
        }
})