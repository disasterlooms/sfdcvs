({
    myAction: function(cmp, event, helper) {
        var rtype = cmp.get("v.recordId");
        if(rtype){
            rtype = rtype.substring(0, 3);
            console.log('type '+rtype);
            if(rtype == '006'){
                cmp.set("v.spacreate", true);
            }else{
                cmp.set("v.spacreate", false);
            }
        }
        
    },
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
                //helper.getrelatedspa(cmp,event);
            }
        }
        
    },    
    showOppmodal: function(component, event, helper) {
        //Toggle CSS styles for opening Modal
        helper.toggleClass(component,'backdrop','slds-backdrop--');
        helper.toggleClass(component,'modaldialog','slds-fade-in-');
        var oppid = event.getParam("oppId");
        console.log('oppid '+oppid);
        component.set("v.oppid", oppid);        
        var spas = $A.get("e.c:displayspas");
        spas.setParams({ "oppId":  oppid});
        spas.fire();        
    },
    spaupdate : function(cmp,event,helper){
        helper.toggle(cmp, event,helper);
        var spas = $A.get("e.c:updatespas");
        spas.fire();        
    },
    handleSelect: function(cmp, event, helper) {
        var sel = event.getParam("value");
        console.log(sel);
        if(sel=='spa'){
            helper.spaCreate(cmp,event,helper);
        }else{
            helper.createBR(cmp,event,helper); 
        }
        
    },
    createSpa : function(cmp,event,helper){        
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
    },
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinnerspa");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    loading: function (cmp, event,helper) {
        var opps = event.getParam("quotes");
        console.log(opps);
        if(opps.length == 0){
            cmp.set("v.loading",'No Related Spas Found');
        }else{
            cmp.set("v.loading",null);
        }
    },
    handleRecordUpdated : function(cmp,event,handler){
        console.log('');
    }
})