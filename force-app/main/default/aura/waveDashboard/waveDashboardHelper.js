({
	getReleatedId : function(cmp,event,helper) {
		console.log('action running');
		console.log(cmp.get("c.getRecId"));
        var action = cmp.get("c.getRecId");
        action.setParams({
            "recordId":cmp.get("v.recordId")
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                console.log('dashboard recid ');
                console.log(resp.getReturnValue());
                var relrecord = resp.getReturnValue();
                cmp.set("v.relatedRecId",relrecord);
               // console.log('substring '+relrecord.substring(0,3));
                if(relrecord.substring(0,3)== 'a0y'){
                    console.log('this is an eval create dashboard');
                    //cmp.set("v.inModal",true);
                   helper.getRecordInfo(cmp,event,helper); 
                }
                //cmp.set("v.objType",relrecord.substring(0,3));
                //helper.createCMP(cmp,event,helper);
            }
            else{
                alert(resp.getError());
            }
        });
        $A.enqueueAction(action);
	},
    getRecordInfo : function(cmp,event,helper) {
         var action = cmp.get("c.getRecordDetail");
        action.setParams({
            "recordId":cmp.get("v.relatedRecId"),
            "fieldNames": "Owner.Name,OwnerId,Name",
            "ObjName":"Eval_Request__c"
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                var relrecord = resp.getReturnValue();
                console.log('eval info');
                console.log(relrecord);
                 //console.log(relrecord[0]);
                cmp.set("v.eval",relrecord); 
                helper.createDash(cmp,event,helper); 
                //cmp.set("v.objType",relrecord.substring(0,3));
                //helper.createCMP(cmp,event,helper);
            }
            else{
                alert(resp.getError());
            }
        });
        $A.enqueueAction(action);
	},
    createDash : function(cmp,event,helper){
        var evalOwnerId = cmp.get("v.eval.Owner.Name");
        /*
        var filter = {
            datasets:{
                "EvalOrders":[{
                    
                    fields:[
                        "EvalOrder.EvalOwner.Name"
                    ],
                    filter:{
                        operator : "in",
                        values:[
                            "Alex Carlos"
                        ]
                    }
                }]
            }
        };
        */
        var filterstring = "{'datasets':{'EvalOrders':[{'fields':['EvalOrder.EvalOwner.Name'],'filter':{'operator':'in','values':['"+evalOwnerId+"']}}]}}"
 		cmp.set("v.filterString", filterstring);
        
        var jsonfilter = JSON.stringify(filterstring,null,2);
        //cmp.set("v.filter",json); ,
                //"filter" : filtertest
        //console.log(evalOwnerId);
        //console.log('owner id');
        //"filter" : jsonfilter ,
                //"filter" : filtertest
        var dashid = cmp.get("v.dashboardId");
        //console.log('createing dash '+dashid);
        //console.log(' filterstring '+filterstring);
        $A.createComponent(
            "wave:waveDashboard",
            {
                "dashboardId": dashid,
                "showTitle": true,
                "showHeader": false,
                "showSharing": false,
                "height" : "900",
                "filter" : filterstring
            },
            function(newButton, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(newButton);
                    cmp.set("v.body", body);
                    console.log('succes');
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    console.log('error dashboard');
                    // Show error message
                }
            }
        );
        
    }
})