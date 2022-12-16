({
	getParentRecId : function(cmp,event,helper) {
        
        
        var action = cmp.get("c.getRecordDetail");
        var recid = cmp.get("v.relatedRecId");
        
        var objname = cmp.get("v.ObjName");
        var objfields = cmp.get("v.parentFieldNames");
        
        action.setParams({
            "recordId": recid,
            "fieldNames": objfields,
            "ObjName": objname
           
        });
        console.log('querry related record Id '+ recid+' obj '+objname+' fieldnames '+objfields);
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                console.log('get related fields '+ resp.getReturnValue());
                
                var relrecord = resp.getReturnValue();
                //console.log(' values from  '+objname+' '+relrecord.Account.POS_Revenue__r.POS_Name__c);
                //console.log('relrecord '+relrecord.Account.Name);
                var parentField = cmp.get("v.parentfieldname");
                cmp.set("v.recordValues",relrecord);
                
                cmp.set("v.parentId",relrecord[parentField]);
                
                console.log('parent id not necessarily opp id '+relrecord[parentField]);
                if(cmp.get("v.dashboardId")){
                    helper.createCMPDashboard(cmp,event,helper);
                }else{
                    
                    helper.createCMP(cmp,event,helper);
                }
                
                
            }
            else{
               var errors = resp.getError();
               if (errors && Array.isArray(errors) && errors.length > 0) {
               var emsg =  errors[0].message;
               console.log('there was an error on getParentRecId action '+emsg);
               }
                
                //alert(resp.getError());
            }
        });
        $A.enqueueAction(action);
		
	},
    createCMP : function(cmp,helper,event){
        var cmpname = cmp.get("v.cmpName");
        if(cmp.get("v.getParentID") == false){
          var recid = cmp.get("v.relatedRecId");  
        }else{
            var recid = cmp.get("v.parentId");
        }
        
        console.log('create comp rec id '+recid);
       
        
        $A.createComponent(
            cmpname,
            {
                "recordId": recid
            },
            function(newCMP, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(newCMP);
                    cmp.set("v.body", body);
                    console.log('crete  cmp sucess');
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error create component (non dashbaroard) " + errorMessage);
                    // Show error message
                }
            }
        );
        
    },
    
    createCMPDashboard : function(cmp,helper,event){
        var cmpname = cmp.get("v.cmpName");
        if(cmp.get("v.getParentID") == false){
          var recid = cmp.get("v.relatedRecId");  
        }else{
            var recid = cmp.get("v.parentId");
        }
        
        var dash = cmp.get("v.dashboardId");
        console.log('create comp dash id '+dash);
        var equalToValue = recid;
        var fieldtoMatch = cmp.get("v.fieldtoMatch");
        console.log('override '+fieldtoMatch);
        if(fieldtoMatch){
            var parentField = cmp.get("v.recordValues");
            console.log('the acct Pos Name shoudl be object object '+ parentField);
            console.log('the account Name '+ parentField.Account.POS_Revenue__r.POS_Name__c);
            equalToValue = parentField.Account.POS_Revenue__r.POS_Name__c;            
		}
        var datsetName = cmp.get("v.dashboarddatsetName");
        //console.log(' dataset name '+datsetName);
        var dashboardFieldtoCompare = cmp.get("v.dashboardFieldtoCompare");
        //console.log(' dahsboard field name '+dashboardFieldtoCompare);
        $A.createComponent(
            cmpname,
            {
                "recordId" : cmp.get("v.parentId"),
                "dashboardId": dash,
                "height": cmp.get("v.dashboardHeight"),
                "filter" : "{'datasets':{'"+datsetName+"':[{'fields':['"+dashboardFieldtoCompare+"'],'filter':{'operator':'matches','values': '"+equalToValue+"'}}]}}"

                
            },
            function(newCMP, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(newCMP);
                    cmp.set("v.body", body);
                    console.log('crete dahsboard cmp sucess');
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error for the dashboard component" + errorMessage);
                    // Show error message
                }
            }
        );
        
    },
    
    
})