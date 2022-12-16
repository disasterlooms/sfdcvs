({
    resellercheck : function(cmp, event, helper) {        
        //helper.toggle(cmp, event,helper);
        alert('Please wait a few seconds...found that the reseller was not attached properly...click ok and SkyNet aka Salesforce will attempt to fix.');
        var action = cmp.get("c.getReseller");
        action.setParams({"recid": cmp.get("v.recordId")
                         });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){            	
                console.log('SkyNet has fixed it! The page is now refreshing this section. You will see it listed on next full refresh. Thanks');
                //helper.toggle(cmp, event,helper);
                alert('Fixed it. This section is now refreshing. Thanks');
                
                $A.get('e.force:refreshView').fire();
            }else{
                //helper.toggle(cmp, event,helper);
                alert('Sorry there was an error, please add Reseller Manually');
            }
        }); 
        $A.enqueueAction(action);
        
    }
})