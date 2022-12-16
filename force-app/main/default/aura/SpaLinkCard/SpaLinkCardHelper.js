({
	toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinnerspa");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    
    createSpa : function(cmp,event,helper){
        var spas = $A.get("e.c:createspas");
        spas.setParams({ "opportunity":  cmp.get("v.opportunity")
                       });
        console.log('send the opp object to event')
        spas.fire();        
    },
    createBR : function(cmp,event,helper){
        var spas = $A.get("e.force:createRecord");
        var oppid = cmp.get("v.opportunity.Id");
        var spaid = cmp.get("v.opportunity.SPA_ID__c")
        spas.setParams({
            "entityApiName": "Quote",
            "defaultFieldValues": {
                'Name' : cmp.get("v.simpleRecord.SPA_ID__c"),
                'OpportunityId' : cmp.get("{!v.simpleRecord.Id}"),
                'Pricebook2Id' : cmp.get("v.simpleRecord.Pricebook2Id"),
                'AccountId' : cmp.get("v.simpleRecord.AccountId"),
                'RecordTypeId' : '0121H000001QBRJ',
                'Spa_Request_Type__c' : 'Bid Register Request'
            }
        });
        console.log('oppid '+cmp.get("v.opportunity.Id"));
        spas.fire();      
    },
    
    spaCreate : function(cmp,event,helper){        
        var spas = $A.get("e.force:createRecord");
        var oppid = cmp.get("v.opportunity.Id");
        var spaid = cmp.get("v.opportunity.SPA_ID__c")
        spas.setParams({
            "entityApiName": "Quote",
            "defaultFieldValues": {
                'Name' : cmp.get("v.simpleRecord.SPA_ID__c"),
                'OpportunityId' : cmp.get("{!v.simpleRecord.Id}"),
                'Pricebook2Id' : cmp.get("v.simpleRecord.Pricebook2Id"),
                'AccountId' : cmp.get("v.simpleRecord.AccountId")
            }
        });
        console.log('oppid '+cmp.get("v.opportunity.Id"));
        spas.fire();        
    }
})