({
	myAction : function(component, event, helper) {
		
	},
    getSales : function(cmp, event, helper) {
        console.log('getting Serials');
        var action = cmp.get("c.getSerialNumber");
        let spiffId = cmp.get("v.recordId");
        //console.log(spiffId+ ' spiff id');        
        let wherestmnt = cmp.get("v.wherestmnt");
        //console.log(wherestmnt+ ' where ');        
        let fields = cmp.get("v.addfields");
        
        console.log(cmp.get("v.orderstmnt")+ ' order ');
        //console.log(cmp.get("v.limitstatement")+ ' limit ');
        //console.log(cmp.get("v.spiffSearch")+' spiffsearch');        
        action.setParams({
            "spiffId": spiffId,
            "wherestmnt" : wherestmnt,
            "addfields" : fields,
            "limitstmt" : 'limit ' +cmp.get("v.limitstatement"),
            "orderstmnt" : cmp.get("v.orderstmnt"),
            "spiffSearch" : cmp.get("v.spiffSearch"),
            "spaId": cmp.get("v.spanumber")
        });
        action.setCallback(this,function(resp){
            console.log('serial checking the apex class');
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                console.log('serial checking sucesss');
                 helper.hideSpinner(cmp,event,helper);
                //pass the products to be displayed
                //
                //console.log('got them Serials');
                var sn = resp.getReturnValue();
                cmp.set("v.serialNumber",sn);
                helper.createSerialDownload(cmp,event,helper);
                helper.hideSpinner(cmp,event,helper);
				//console.log(sn);                
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
                 var erm = resp.getError();
                 console.log(erm[0]);
                 console.log('got error on serials');
                 cmp.set("v.serialsFound",false);
                 helper.hideSpinner(cmp,event,helper);
            }
        });
        $A.enqueueAction(action);
        console.log('show account info');
        console.log(cmp.get("v.account"));
    },
    searchSerialNumbers : function(cmp,event,helper){              
        helper.searchSerials(cmp,event,helper)
        helper.showSpinner(cmp,event,helper);
    },
    checkAllCheckboxes : function(cmp, event, helper) {
        var checkCmp = cmp.find("checkbox");
        var value = checkCmp.get("v.value");
        var checkboxes = cmp.find("DependentCheckbox");
        var i;
        for (var i = 0; i < checkboxes.length; i++){
            checkboxes[i].set("v.value",value);
        }
    },
    addSelected : function(cmp, event, helper) {
        //console.log('add selected');
        helper.showSpinner(cmp, event,helper);
        var checkboxes = cmp.find("DependentCheckbox");
        let spiffId = cmp.get("v.recordId");
        console.log('spiff id');
        var prods =[];        var i;
        for (var i = 0; i < checkboxes.length; i++){
            if(checkboxes[i].get("v.value")==true){
                var id = checkboxes[i].get("v.name");
                prods.push({'sobjectType':'Asset',
                            'Id': id }); 
            }
        }
        cmp.set("v.claimSerials",prods);
        var sns = cmp.get("v.claimSerials");
        //var e = '';
        let wherestmnt = cmp.get("v.wherestmnt");    
        let fields = cmp.get("v.addfields");
        var action = cmp.get("c.updateSpiffs");
        action.setParams({"serials": sns ,
                          "spiffId": spiffId,
                          "wherestmnt" : wherestmnt,
                          "addfields" : ' ',
                          "limitstmt" : cmp.get("v.limitstatement"),
                          "orderstmnt" : cmp.get("v.orderstmnt"),
                          "spiffSearch" : cmp.get("v.spiffSearch"),
            			  "spaId": cmp.get("v.spanumber")
                         });
        action.setCallback(this,function(resp){
            console.log(sns);
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                console.log('updated spiff');
                cmp.set("v.serialNumber",resp.getReturnValue());
                console.log(resp.getReturnValue());
                helper.hideSpinner(cmp,event,helper);
                $A.get('e.force:refreshView').fire();
               
            }
            else{
                helper.hideSpinner(cmp,event,helper);
                let errors = resp.getError();
                console.log('err '+ errors);
                 console.log('err '+ errors[0].message);
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                console.log('Error on Serial ' + errors[0]);
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                    console.log('Error on Serial ' + message);
                }   

                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    }
})