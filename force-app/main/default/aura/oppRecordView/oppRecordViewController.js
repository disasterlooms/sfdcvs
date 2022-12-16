({
    handleChangeWave : function(cmp, event, helper) {
        console.log('opp id ');
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
                cmp.set("v.oppid",oppid);
            }
        }
        
    },
    editOpp : function(cmp,event,handler){
        var oppid = cmp.get("v.oppid");
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": oppid
        });
        editRecordEvent.fire();
    },
    openOpp : function(cmp,event,handler){
        var baseURL = 'https://viewsonic.lightning.force.com/';
        var oppid = cmp.get("v.oppid");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": baseURL+oppid 
        });
        //urlEvent.fire();
        window.open('/' + oppid);  
        
    },
    navigateToRecord : function(cmp , event, helper){
        console.log('runnig open opp page')
     //window.open('/' + event.getParam('recordId'));
    },
    handleLoad : function(cmp,event,helper){
        
    }
})