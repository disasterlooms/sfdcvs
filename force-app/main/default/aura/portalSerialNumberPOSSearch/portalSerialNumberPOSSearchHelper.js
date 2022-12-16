({
	searchSerials : function(cmp,event,helper) {
        console.log('getting Serials');
        var action = cmp.get("c.getSerialNumber");
        let spiffId = cmp.get("v.recordId");
        console.log(spiffId+ ' spiff id');        
        //let wherestmnt = cmp.get("v.wherestmnt");
        let prod = cmp.get("v.product");
        var res = cmp.get("v.reseller");
        if(!res){
            res = '';
        }
        var disti = cmp.get("v.distributor"); 
        var enduser = cmp.get("v.enduser");        
        var serial = cmp.get("v.name");
        var spanum =  cmp.get("v.spanumber");
        var orderNum =  cmp.get("v.order");
        var orderQuery = '';
        if(orderNum){
          orderQuery =  " and Order__c like '"+orderNum+"%'";
        }
        console.log('spanum '+ spanum);
        console.log('order number query '+ orderNum);
       
        //and calendar_Month(PuchaseDate) = 
        //and calendar_Year(PuchaseDate) =
       
        var saleMo = cmp.get("v.SaleMonth");
        var SaleYr = cmp.get("v.SaleYear");
         console.log('sal mo '+ saleMo) ;
        console.log('sal yr '+ SaleYr) ;
        
        
        let wherestmnt = " where product__c like '"+prod+"%' and Reseller__c like '"+res+"%'and SerialNumber like '"+serial+"%'"+
         "and Distributor__c like '"+disti+"%'and End_User__c like '"+enduser+"%' and SpaId__c like '"+spanum+"%' "+orderQuery;
        
        console.log('wher sttm good ');
        if(saleMo){
            if(!SaleYr){
               SaleYr = 2021; 
            }
            wherestmnt = wherestmnt+' and calendar_Month(PurchaseDate) =  '+saleMo+' and calendar_Year(PurchaseDate) =  '+SaleYr+' ';
        }
        //console.log('yr mo '+saleMo+saleYr);
        
        //cmp.get("v.wherestmnt");
        
        console.log(' where statement ' +wherestmnt);
        
        let fields = cmp.get("v.addfields");
        
        console.log(cmp.get("v.orderstmnt")+ ' order ');
        console.log(cmp.get("v.limitstatement")+ ' limit ');
        console.log(cmp.get("v.spiffSearch")+' spiffsearch');        
        action.setParams({
            "spiffId": spiffId,
            "wherestmnt" : wherestmnt,
            "addfields" : fields,
            "limitstmt" : 'limit '+ cmp.get("v.limitstatement"),
            "orderstmnt" : cmp.get("v.orderstmnt"),
            "spiffSearch" : false,
            "spaId": spanum
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                //
                console.log('got them Serials');
                cmp.set("v.serialNumber",resp.getReturnValue());
                helper.createSerialDownload(cmp,event,helper);
                helper.hideSpinner(cmp,event,helper);
                console.log(resp.getReturnValue());
                if(resp.getReturnValue().length > 0){
                    cmp.set("v.serialsFound",true);
                }else{
                    cmp.set("v.serialsFound",false);
                }
            }
            else{
                helper.hideSpinner(cmp,event,helper);
                console.log(resp.getError());
                console.log('got error on serials');
            }
        });
        $A.enqueueAction(action);
        console.log('show account info');
        console.log(cmp.get("v.account"));
		
	},
    hideSpinner : function (cmp, event,helper) {
        console.log('hide spinner');
        var spinner = cmp.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    showSpinner : function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    createSerialDownload : function(cmp,event,helper){
        //console.log('serial download file array creation');
        var serials = cmp.get("v.serialNumber");
        console.log(serials);
        let serialDownload = [];
        for (let i = 0; i < serials.length; i++) {
            serialDownload[i] = {
                SerialNumber: serials[i].SerialNumber,
                Product__c : serials[i].Product__c,
                End_User__c : serials[i].Account.Name, 
                PurchaseDate : serials[i].PurchaseDate,
                Reseller__c : serials[i].Reseller__c,
                Spiff_Request__c: serials[i].Spiff_Request__c,
                Id: serials[i].Id,
            };
        }
        cmp.set("v.recordsToDownload",serialDownload);
        console.log('serials for download created ');
        //console.log(cmp.get("v.recordsToDownload"));

    }

    
})