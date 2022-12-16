({
	myAction : function(cmp, event, helper) {
        var action = cmp.get("c.getReps");
        var d = new Date();
        var q = {'1':'1', '2':'1','3':'1','4':'2', '5':'2', '6':'2', '7':'3', '8':'3','9':'3','10':'4', '11':'4','12':'4'} ;
            
        cmp.set("v.title", 'Create My Teams Quotas for Q'+q[d.getMonth()+1]);
        cmp.set("v.quarter", q[d.getMonth()+1]);
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                var users = resp.getReturnValue();
                cmp.set("v.myusers", users);
                console.log(users);
                console.log('users');
            }
            else{
                alert(resp.getError());
            }
        });
        $A.enqueueAction(action);
        
        var fields = cmp.get("c.myFields");
        
        fields.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                var values = resp.getReturnValue();
                var labels = values.QuotaLabels__c
                var label = [];
                
                label = labels.split(","); 
                cmp.set("v.labels",label);
                
                
                var fields = values.QuotaFields__c;
                var field = [];
                field = fields.split(","); 
                cmp.set("v.fields",field);
                 var iter = 0;
                 for (var i = 0; i < label.length; i ++) { 
                     iter = iter+1;
                     var colindex = i;
                                          
                 }                
                helper.createTablebody(cmp,event,helper);
                console.log('number of fields');
                console.log(iter);
            }
            else{
                alert(resp.getError());
            }
        });
        $A.enqueueAction(fields);

        var quotas = [];
    },
    valuecheck : function(cmp,event,helper){
        var sobj = cmp.get("v.myusers");
        console.log(sobj);
        var userid = event.getSource().get("v.title");
        console.log(userid);
        var quota = event.getSource().get("v.value");
        console.log(quota);
        var field = event.getSource().get("v.name");
        console.log('field ');
        console.log('x'+ field +'x');
        var index = event.getSource().get("v.class");
        
        cmp.set("v.quotas["+index+"].Id", 'a09A000000DfzXgIAJ');
        cmp.set("v.quotas["+index+"].Sales_Rep__c", userid);
        cmp.set("v.quotas["+index+"]."+field, quota);        
        
        var crobj =[];
        
        var sobj2 = cmp.get("v.quotas");
        
        console.log(sobj2);
    },
    cquotas : function(cmp,event,helper){
        helper.toggle(cmp);
        var cquotas = cmp.get("c.createQuotas");
        var quotas = cmp.get("v.quotas");
        var i =0;
        
        //adding an Id to the array and then in the 
        //sever side controller, will null the value
        /*
        for(var i = 0; i< quotas.length; i ++){
            quotas[i].Id = 'a09A000000DfzXgIAJ';            
        }
        */
        console.log('what is sent to server');
        console.log(quotas);
        
        cquotas.setParams({"quotas" : quotas
                          });
        
        cquotas.setCallback(this, function(data) {
        var rslt = data.getState();
       		if (rslt === "SUCCESS"){
                console.log('success');
                helper.toggle(cmp);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Current Quarter Quotas Created",
                    "message": "You have created this quarters Quotas, edits must be done individually, not on this page",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/lightning/page/home?0.source=aloha"
                });
                urlEvent.fire();
            }else{
                helper.toggle(cmp);
                alert('There were some errors on the save');
            }
        });
        $A.enqueueAction(cquotas);
    }
    
})