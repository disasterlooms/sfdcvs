({
	getData : function(cmp, event, helper) {
        helper.getopps(cmp, event,helper);
        var saction = cmp.get("c.getStatus");
        saction.setCallback(this, function(data) {
        cmp.set("v.status", data.getReturnValue());
        });        
        $A.enqueueAction(saction);        
        var guser = cmp.get("c.getUser");        
        guser.setCallback(this, function(data) {
        cmp.set("v.user", data.getReturnValue());
        });        
        $A.enqueueAction(guser);
	},
     newproduct: function(cmp, event, helper) {
        console.log($A.get("e.c:newproduct"));
        console.log('statuse '+cmp.get("v.status"));
		var opp = event.getSource().get("v.value");
		console.log(opp);
		var userevent = $A.get("e.c:newproduct");
        userevent.setParams({ "oppId":  opp,
                             "status" :  cmp.get("v.status")});
        userevent.fire();
        console.log('firing new prod event');
    },
    gotoRelatedList : function (component, event, helper) {
        var oppid = event.getSource().get("v.value");
        console.log(oppid);
        var relatedListEvent = $A.get("e.force:navigateToRelatedList");
       	relatedListEvent.setParams({
            "relatedListId": "OpportunityLineItems",
            "parentRecordId": oppid
        });
        relatedListEvent.fire();
    },
    pupdate : function(cmp, event, helper) {
        //show the spinner. Get values from both 
        //opportunities and line items
        //update both and give results
        //once results are succesful, then remove spinner
        helper.toggle(cmp,event,helper);
        var opps = cmp.get("v.opportunities");
        console.log('list of pipline');
        console.log(opps);
        var i;    
        var z;
        var olines=[]; 
        //for loop will go get the child records of opps and then combine
        //the arrays in one array so it can be sent to the server side
        //controller and 
        for (i = 0; i < opps.length; i++) { 
             for (z = 0; z < opps[i].OpportunityLineItems.length; z++) { 
                 olines.push(opps[i].OpportunityLineItems[z]);
             }
         }
        var opplines = cmp.get("v.opportunities[0].OpportunityLineItems");
        var action = cmp.get("c.updateopps");
        action.setParams({"opps": cmp.get("v.opportunities"),
                          "lines" : olines});
        action.setCallback(this, function(data) {
        var rslt = data.getState();
       		if (rslt === "SUCCESS"){
            	helper.getopps(cmp,event,helper); 
                helper.toggle(cmp,event,helper);
            }else{
                alert('There were some errors on the save');
                helper.getopps(cmp,event,helper);
                helper.toggle(cmp,event,helper);
            }
        });
        $A.enqueueAction(action);
	},
    deleteprod: function (cmp, event,helper) {
       helper.toggle(cmp,event,helper);
       var prodid = event.getSource().get("v.value");
       
       //var spinner = document.getElementById("spinnerdiv");
       //$A.util.removeClass(spinner, 'hideme'); 
       var del = cmp.get("c.deleteprod");
       console.log(prodid);
       var action = cmp.get("c.delProd");
        action.setParams({"prodid" : prodid});
        action.setCallback(this, function(data) {
            var rslt = data.getState();
       		if (rslt === "SUCCESS"){
                //refresh the searches post delete;   
                helper.getopps(cmp,event,helper);
                helper.toggle(cmp,event,helper);
                    
            }else{
                 //refresh the searches post delete  
                helper.getopps(cmp,event,helper);
                helper.toggle(cmp,event,helper);   
                alert('There were some errors on the delete');
            }
        });
        $A.enqueueAction(action);
       
    },
    displayOpportunities: function(component, event, helper) {
		var opp = event.getSource().get("v.value");
		console.log(opp);
		var spas = $A.get("e.c:displayopp");
        spas.setParams({ "oppId":  opp});
        spas.fire();
    }
})