({
	helperMethod : function() {
		
	},    
    newSpiff : function(cmp,event,handler){
        console.log('new spiff');
       createRecordEvent.setParams({
            "entityApiName": "Customer_Contact_Request__c"
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
                'Name' : 'Auto Generated - Do Not Change',
                'Country__c' : 'United States',
                'Distributor_Account__c' : false,
                'Type' : 'Project'
            }
        });
        createRecordEvent.fire();
        
    }
})