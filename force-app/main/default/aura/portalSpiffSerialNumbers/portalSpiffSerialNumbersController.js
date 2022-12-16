({
	myAction : function(component, event, helper) {
		
	},
    getSales : function(cmp, event, helper) {
        console.log('getting Serials');
        var action = cmp.get("c.getSerialNumber");
        let spiffId = cmp.get("v.recordId");     
        let wherestmnt = cmp.get("v.wherestmnt");   
        let fields = cmp.get("v.addfields");
        
        console.log(cmp.get("v.orderstmnt")+ ' order ');      
        action.setParams({
            "spiffId": spiffId,
            "wherestmnt" : wherestmnt,
            "addfields" : ' ',
            "limitstmt" : cmp.get("v.limitstatement"),
            "orderstmnt" : cmp.get("v.orderstmnt"),
            "spiffSearch" : cmp.get("v.spiffSearch")
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                //
                //console.log('got them Serials');
                var sn = resp.getReturnValue();
                cmp.set("v.serialNumber",sn);
                helper.hideSpinner(cmp,event,helper);
                
                //console.log(resp.getReturnValue());
                if(sn.length > 0){
                    cmp.set("v.serialsFound",true);
                    cmp.set("v.reseller", sn[0].Reseller__c);
                }else{
                    cmp.set("v.serialsFound",false);
                }
            }
            else{
                 console.log(resp.getError());
                 console.log('got error on serials');
                 cmp.set("v.serialsFound",false);
                 helper.hideSpinner(cmp,event,helper);
            }
        });
        $A.enqueueAction(action);
        console.log('show account info');
        console.log(cmp.get("v.account"));
    }
})