({
    aliasName : function(cmp, event, helper) {
        var params = event.getParams();
        var payload = params.payload;
        // console.log('payload');
        if(payload){
            var step = payload.step;
            var dataArray = payload.data;
            //console.log('data');
            var data = dataArray[0];
            if(data){
                console.log('data 2');
                console.log(data);
                
                var aliasname = data['ResellerName'];
                cmp.set("v.aliasname",aliasname);
                if(aliasname){
                    cmp.set("v.disabled",true);
                    console.log('reserch');
                    helper.getAliases(cmp,event,helper);
                    //$A.get("e.wave:discover").fire();
                }
            }
        }
        console.log(cmp.get("v.aliasname")+' alias');
        
    },
    editSelected : function(cmp,event,helper){
        var ev = event.getSource().get("v.value");
        console.log(ev);
        var posrec = ev;
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": posrec
        });
        editRecordEvent.fire();
        
        
    },
    clone : function(cmp,event,helper){
        var ev = event.getSource().get("v.value");
        console.log('index');
        console.log(ev);
        var alsname = cmp.get("v.aliasname");
        var posname = cmp.get("v.aliases["+ev+"].Name");
        var sfdcname = cmp.get("v.aliases["+ev+"].SFDC_Account__c");
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "POSAccountAliases__c",
            "defaultFieldValues": {
                'Name' : posname,
                'SFDC_Account__c' : sfdcname,
                'Reseller_Alias__c' : alsname,
                'Channel__c' : 'AV'
            }
        });
        createRecordEvent.fire();
        
    },
    newAlias : function(cmp,event,helper){
         var alsname = cmp.get("v.aliasname");
         var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "POSAccountAliases__c",
            "defaultFieldValues": {
                'Name' : alsname,
                'Reseller_Alias__c' : alsname,
                'Channel__c' : 'AV'
            }
        });
        createRecordEvent.fire();
        
    },
    newRecPage : function(cmp,event,handler){
        console.log('nav to new page')
    }
})