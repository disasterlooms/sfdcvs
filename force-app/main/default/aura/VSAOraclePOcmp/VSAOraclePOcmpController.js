({
    myAction : function(cmp, event, helper) {
        //helper.getPOInfo(cmp,event,helper);
    },
    poEASearch :function(cmp,event,helper){
        //console.log('change detected');
        var params = event.getParams();
        var payload = params.payload;
        // console.log('payload');
        if(payload){
            var step = payload.step;
            // console.log('step');
            // console.log(step);
            var dataArray = payload.data;
            //console.log('data');
            console.log('data array 2');
            console.log(dataArray[0]);
            console.log(dataArray);
            var data = dataArray[0];
            if(data){
                console.log('data 2');
                console.log(data);
                console.log(data[0]);                
                var ponumber = data['Cust_PO_Number'];
                cmp.set("v.ponumber",ponumber);
                if(ponumber){
                    console.log(ponumber);
                    cmp.set("v.disabled",true);
                    console.log('reserch');
                    helper.showspinner(cmp,event,helper);
                    console.log('added remove spinner');
                    helper.getPOInfo(cmp,event,helper);
                    //$A.get("e.wave:discover").fire();
                    
                    
                }
                
            }
        }
        
        
        
    },
    poSearch : function(cmp,event,helper){
        cmp.set("v.disabled",true);
        console.log('reserch');
        helper.showspinner(cmp,event,helper);
        helper.getPOInfo(cmp,event,helper);
    },
    handleDiscoverResponse : function(cmp,event,helper){
        console.log('discover response running');
        var devname =  event.getParam("developerName");
        console.log('devname');
        console.log(devname);
        var params = event.getParams();
        var payload = params.payload;
        
        console.log('params and payload');
        console.log(params);
        console.log(payload);
        
        
    },
    handleLoad : function(cmp,event,helper){
        
    },
    
    waybillaction : function(cmp,event,helper){
        var siteurl = event.getSource().get("v.value");
        console.log(siteurl);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": siteurl
        });
        //urlEvent.fire();
        
    },
    
    //START: Added by Shweta: SR:19408
  RedirectSpaPage : function(cmp,event,helper){
        debugger;
        var spaNo = event.getSource().get("v.value");         
	var action = cmp.get("c.getSpa");
    action.setParams({"spaNo":spaNo});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                debugger;
                var storeResponse = response.getReturnValue();
    			var navEvt = $A.get("e.force:navigateToSObject");
   				navEvt.setParams({
    				 "recordId":  storeResponse.Id,
    				 "slideDevName": "detail"
 					   });
 			   navEvt.fire();          
            }
             });
			$A.enqueueAction(action);
    
 }
    //END:Added by Shweta: SR:19408
})