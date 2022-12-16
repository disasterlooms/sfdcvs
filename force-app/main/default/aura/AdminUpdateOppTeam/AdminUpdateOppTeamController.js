({
	myAction : function(component, event, helper) {
		
	},
    hideModal : function(cmp, event, helper) {
		 //Toggle CSS styles for hiding Modal
		helper.hide(cmp, event, helper);
	},
    showmodal : function(cmp, event, helper) {
        helper.show(cmp, event, helper);
    },
    oppartners : function(cmp, event, helper) {
        console.log('opp team');
        var accts = cmp.get("c.communityuser");
        var email = cmp.get("v.email");
        helper.toggle(cmp,event,helper);
        accts.setParams({"email": email
                         });
        accts.setCallback(this, function(data) {
            var rslt = data.getState();
            helper.toggle(cmp,event,helper);
       		if (rslt === "SUCCESS"){                
            	
                helper.hide(cmp,event,helper);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Completed",
                    "message": "User added to appropriate opp teams",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
            }else{
                alert('There were some errors on the save');                
            }
        });        
        $A.enqueueAction(accts);        
	},
    oppteamupdate : function(cmp, event, helper) {
        console.log('opp team');
        var accts = cmp.get("c.oppTeam");
        var email = cmp.get("v.email");
        helper.toggle(cmp,event,helper);
        accts.setParams({"email": email
                         });
        accts.setCallback(this, function(data) {
            var rslt = data.getState();
            helper.toggle(cmp,event,helper);
       		if (rslt === "SUCCESS"){                
            	
                helper.hide(cmp,event,helper);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Completed",
                    "message": "User added to appropriate opp teams",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
            }else{
                alert('There were some errors on the save');                
            }
        });        
        $A.enqueueAction(accts);        
	},
    acctransfer : function(cmp, event, helper) {
        console.log('opp team');
        var accts = cmp.get("c.oppTeam");
        var email = cmp.get("v.email");
        helper.toggle(cmp,event,helper);
        accts.setParams({"email": email
                         });
        accts.setCallback(this, function(data) {
            var rslt = data.getState();
            helper.toggle(cmp,event,helper);
       		if (rslt === "SUCCESS"){                
            	
                helper.hide(cmp,event,helper);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Completed",
                    "message": "User added to appropriate opp teams",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
            }else{
                alert('There were some errors on the save');                
            }
        });        
        $A.enqueueAction(accts);        
	},
    opptransfer : function(cmp, event, helper) {
        console.log('opp team');
        var accts = cmp.get("c.oppTrans");
        var emailto = cmp.get("v.emailto");
        var emailfrom = cmp.get("v.emailfrom");
        helper.toggle(cmp,event,helper);
        accts.setParams({"emailto": emailto,
                         "emailfrom" : emailfrom
                         });
        accts.setCallback(this, function(data) {
            var rslt = data.getState();
            helper.toggle(cmp,event,helper);
       		if (rslt === "SUCCESS"){                
            	
                helper.hide(cmp,event,helper);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Completed",
                    "message": "User added to appropriate opp teams",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
            }else{
                alert('There were some errors on the save');                
            }
        });        
        $A.enqueueAction(accts);        
	}
    
    
})