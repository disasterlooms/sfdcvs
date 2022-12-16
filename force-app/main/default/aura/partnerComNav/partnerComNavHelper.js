({
    helperMethod : function() {
        
    },
    newContact : function(cmp,event,helper){
        console.log('New Contact Request');
        createRecordEvent.setParams({
            "entityApiName": "Contact"
        });
        createRecordEvent.fire();
        
    },
    newDeal : function(cmp,event,helper){
        var rectype = '012A0000000nzaY';
        var channel = 'Distribution';
        let reseller = cmp.get("v.reseller");
        console.log('newdeal');
        let subType = '';
        let rcon = '';
            if(reseller){
            subType = 'Portal Reseller';
            }else{
                subType = 'Portal Distribution'; 
            }
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Opportunity",
            "defaultFieldValues": {
                'Submission_Type__c' : subType,
                'StageName' : 'Development',
                'Name' : 'New Opportunity and Quote',
                'Country__c' : 'United States',
                'Distributor_Account__c' : false,
                'Type' : 'Project'
            }
        });
        createRecordEvent.fire();
        
    },
    newRequest : function(cmp,event,helper){
        console.log('New Con Request');
        createRecordEvent.setParams({
            "entityApiName": "Customer_Contact_Request__c"
        });
        createRecordEvent.fire();
    }

})