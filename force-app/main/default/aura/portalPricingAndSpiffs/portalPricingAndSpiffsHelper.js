({
	helperMethod : function() {
		
	},
    toggleClass: function(cmp,componentId,className) {
        var modal = cmp.find(componentId);
        $A.util.removeClass(modal,className+'hide');
        $A.util.addClass(modal,className+'open');
    },
    toggleClassInverse: function(cmp,componentId,className) {
        var modal = cmp.find(componentId); 
        $A.util.addClass(modal,className+'hide');  
        $A.util.removeClass(modal,className+'open');
    },
    hideSpinner: function (cmp, event,helper) {
        var spinner = cmp.find("spinner");
        $A.util.addClass(spinner,"slds-hide");
    },
    showSpinner: function (cmp, event,helper) {
        var spinner = cmp.find("spinner");
        $A.util.removeClass(spinner,"slds-hide");
    },
    getAdminRecords : function(cmp,event,helper){
    console.log('Admin getting records');
        var id = cmp.get("v.recordId");
        var records = cmp.get("c.getAdminRecords");
        var prods = cmp.find('search').get('v.value');
        if(prods == null){
            prods = '%'+'%';
        }else{
            prods = '%'+prods+'%';
        }
        records.setParams({"spiffReq" : cmp.get("v.spiffReq"),
                           "prod" : prods,
                           "recordId": id});
        records.setCallback(this,function(resp){
            let state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                console.log('sucess from the callback on spiff rewards');
                console.log( resp.getReturnValue());
                cmp.set("v.records" , resp.getReturnValue());
                var rec = resp.getReturnValue();
                                
                helper.hideSpinner(cmp,event,helper);
            }else{
                console.log('error gettin spa account info');
                let ermsg = resp.getError();
                ermsg = ermsg[0].message;
                cmp.set("v.errMsg",'There was an error messgae. Please send support ticket with message. '+ermsg);
                console.log(resp.getError());
                 helper.hideSpinner(cmp,event,helper);
            }            
        });
        $A.enqueueAction(records);   
    },
    
    
    getRecords : function(cmp,event,helper){
          console.log('User getting records');
        var records = cmp.get("c.getProductInfo");
        var prods = cmp.find('search').get('v.value');
        if(prods == null){
            prods = '%'+'%';
        }else{
            prods = '%'+prods+'%';
        }
        records.setParams({"spiffReq" : cmp.get("v.spiffReq"),
                           "prod" : prods});
        records.setCallback(this,function(resp){
            let state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                console.log('sucess geting records');
                console.log( resp.getReturnValue());
                cmp.set("v.records" , resp.getReturnValue());
                 helper.hideSpinner(cmp,event,helper);
            }else{
                console.log('error gettin spa account info');
                let ermsg = resp.getError();
                ermsg = ermsg[0].message;
                cmp.set("v.errMsg",'There was an error messgae. Please send support ticket with message. '+ermsg);
                console.log(resp.getError());
                 helper.hideSpinner(cmp,event,helper);
            }            
        });
        $A.enqueueAction(records);   
    }
})