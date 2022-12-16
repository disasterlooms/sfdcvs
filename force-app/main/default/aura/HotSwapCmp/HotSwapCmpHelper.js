({
    getUpdateSpaProducts:function(component,productList) {
        //debugger;
        var currentRecord =component.get("v.recordId");
        var hotSwapRecord = component.get("v.newHotSwapRecord");// Added by Shweta for creating HotSwap Records for  Hotswap project on 27-10-2022
        var action = component.get("c.getUpdateSpaProducts");
        action.setParams({"recordId":currentRecord,"htswap":hotSwapRecord,"spaProducts":productList});// Added "htswap":hotSwapRecord by Shweta for creating HotSwap Records for  Hotswap project on 27-10-2022
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger;
         var storeResponse = response.getReturnValue();
                //Start: Added by Shweta for creating HotSwap Records for  Hotswap project on 27-10-2022
                if(storeResponse==="Hotswap Record Created"){
                          var toastEvent = $A.get("e.force:showToast");  
                 
                     toastEvent.setParams({
                    "type":"Success",
                    "title": "Success!",
                    "duration":"5000",
                    "message": "Quote submitted for Hot Swap Approval Successfully"
                });   
               toastEvent.fire();
               $A.get("e.force:closeQuickAction").fire();
                }
         else if(storeResponse==="No Hotswap Record Created"){
                          var toastEvent = $A.get("e.force:showToast");  
                 
                     toastEvent.setParams({
                    "type":"Error",
                    "title": "Error!",
                    "duration":"5000",
                    "message": "Quote cannot be submitted as a previous Hot swap is pending approval."
                });   
               toastEvent.fire();
               $A.get("e.force:closeQuickAction").fire();
                }
          
                 
          //End: Added by Shweta for creating HotSwap Records for  Hotswap project on 27-10-2022      
            }else{
                console.log('error');
                let errors = response.getError();
                var message = errors[0].message;
                console.log(message);
                console.log(errors);

                
            }
        });
        $A.enqueueAction(action);
     
        
    },
	 getSpaProducts : function(component) {
		//debugger;
        var currentRecord =component.get("v.recordId");
        //var reason = component.get("v.reason");
        var action = component.get("c.getSpaProducts");
        action.setParams({"recordId":currentRecord});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //debugger;
                var storeResponse = response.getReturnValue();
                component.set("v.spaProductRecords",storeResponse);
                 
                
            }else{
                var errmsg = response.getError();
                var messages = '';
                for(var i = 0; i < errmsg.length; i++){
                    messages = messages + '\n\n'+errmsg[i].message;
                }
                var toastEvent = $A.get("e.force:showToast");               
                toastEvent.setParams({
                    "duration":10000,
                    "type":"Error",
                    "title": "Error!",
                    "message": messages
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
                
            }
        });
        $A.enqueueAction(action);
     }
})