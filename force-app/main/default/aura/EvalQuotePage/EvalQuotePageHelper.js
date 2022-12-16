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
            if (rslt === "SUCCESS"){
                cmp.set("v.units", data.getReturnValue());
                console.log(data.getReturnValue());
                //helper.spinnerhide(cmp, event,helper);    
            }else{
                //helper.spinnerhide(cmp, event,helper);
                alert(rslt.getError()); 
            }
        });
        $A.enqueueAction(action);
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
        $A.util.toggleClass(units, 'slds-hide');
        var flow = cmp.find("flowquote");
        var flowdiv = cmp.find('flow');
        console.log(flow);
        var units = cmp.find('evalunits');
        var inputVariables = [
               {
                  name : "id",
                  type : "String",
                  value: cmp.get("v.recordId")
               },
            {
                name : "quoteid",
             	type : "String",
             	value : cmp.get("v.quoteid")
            }
            ];
        flow.startFlow("EvalUnitsQuoteLightning" , inputVariables);
    },
    tablehide : function(cmp,event,helper){
        var units = cmp.find('evalunits');
        $A.util.toggleClass(units, 'slds-hide');
    },
 })