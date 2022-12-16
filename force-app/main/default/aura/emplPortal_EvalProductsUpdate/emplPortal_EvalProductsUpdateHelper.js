({
    helperMethod : function() {
        
    },

    showunits : function(cmp, event, helper){
        var recid = cmp.get("v.recordId");
        console.log('helper recid');
        console.log(recid);
        var action = cmp.get("c.getUnits");
        action.setParams({"recordId": recid
                         });
        action.setCallback(this, function(data) {
            var rslt = data.getState();
            helper.hideSpinner(cmp,event,helper);
            if (rslt === "SUCCESS"){
                helper.hideSpinner(cmp,event,helper);
                var unitRecords = data.getReturnValue();
                var quoteid = cmp.get("v.quoteid");
                console.log('quote id '+quoteid);
                for (var i = 0; i < unitRecords.length; i++){
                    if(unitRecords[i].Eval_Quote__c == quoteid){
                        unitRecords[i].Quote_Product__c = true;
                        //cmp.set("v.quoted",true);
                        console.log('quoted unit '+unitRecords[i].Eval_Quote__c);
                    }else{
                        unitRecords[i].Quote_Product__c = false;
                        console.log('not on quote unit '+unitRecords[i].Eval_Quote__c);
                    }

                }
                console.log('unit field values ');
                console.log(unitRecords);
                cmp.set("v.units",unitRecords );
                var rec = cmp.get("v.records");
                var total = parseInt(cmp.get("v.totalEvalPrice"));
                cmp.set("v.TotalPrice", total);
                if(rec.length == 0){
                    cmp.set("v.records",data.getReturnValue() );
                }
                console.log('eval products ');
                console.log(data.getReturnValue());
                //helper.spinnerhide(cmp, event,helper);    
            }else{
                helper.hideSpinner(cmp,event,helper);
                //helper.spinnerhide(cmp, event,helper);
                alert(rslt.getError()); 
            }
        });
        $A.enqueueAction(action);
    },
    showSpinner: function (cmp, event,handler) {
        var spinner = cmp.set("v.toggleClass","");
    },
    hideSpinner: function (cmp, event,handler) {
        var spinner = cmp.set("v.toggleClass","slds-hide");
    },
    table : function(component,event,helper){
        var units = component.find('evalunits');
        $A.util.toggleClass(units, 'slds-hide');
        
        var table = component.find('billing');
        $A.util.toggleClass(table, 'slds-hide');
    },
    spinner: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinnerpart");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    flow : function(cmp,event,helper){
        debugger;
        console.log('flowname');
        var flowname = cmp.get("v.flowname");
        console.log(flowname);
        var units = cmp.find('evalunitsv2');
        $A.util.toggleClass(units, 'slds-hide');
        var flow = cmp.find("flowquote");
        var flowdiv = cmp.find('flow');
        console.log(flow);
        var recid = cmp.get("v.recordId");
        
        var quoteid = cmp.get("v.quoteid")
        
        console.log('qutoe and rec');
        console.log(quoteid+' '+recid);
        if(quoteid != null && quoteid != '' && quoteid != undefined  ){
           var inputVariables = [
            {
                name : "id",
                type : "String",
                value: recid
            },
            {
                name : "quoteid",
                type : "String",
                value : quoteid
            }
        ];
            console.log('there is a quote id');
        }else{
           var inputVariables = [
            {
                name : "id",
                type : "String",
                value: recid
            }
        ];
            console.log('no quote id');
        }
        
        flow.startFlow( flowname, inputVariables);
    },
    tablehide : function(cmp,event,helper){
        var units = cmp.find('evalunits');
        $A.util.toggleClass(units, 'slds-hide');
    },  
    
    //Prasad: Added a Method accesscheck 
    
    accessCheck : function(cmp,event, helper){
         var action = cmp.get("c.getAccessCheck");        
         action.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){                  
                  cmp.set("v.accessCheck",data.getReturnValue());
            }else{
               
            }
        });
        $A.enqueueAction(action);
        helper.showunits(cmp,event,helper);
       
    },
 })