({
	myAction : function(cmp, event, helper) {
        var reps = cmp.get("c.getReps");        
        reps.setCallback(this, function(data) {
        cmp.set("v.salesreps", data.getReturnValue());
        });        
        $A.enqueueAction(reps);
        console.log('what is value of reps');
        console.log(cmp.get("v.salesreps"));
        helper.myAction(cmp, event,helper);
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
        var industries = cmp.get("c.getIndustries");        
        industries.setCallback(this, function(data) {
        cmp.set("v.industries", data.getReturnValue());
        });        
        $A.enqueueAction(industries);       
        var family = cmp.get("c.getProdTypes");        
        family.setCallback(this, function(data) {
        cmp.set("v.families", data.getReturnValue());
        });        
        $A.enqueueAction(family);
        
	},
    staus : function(cmp, event, helper) {
        var action = cmp.get("c.getStatus");
        action.setCallback(this, function(data) {
        cmp.set("v.status", data.getReturnValue());
        });
        $A.enqueueAction(action);
	},
    search : function(cmp, event, helper) {
        helper.myAction(cmp, event,helper);
	},
    clear : function(cmp, event, helper) {
        cmp.set("v.product",'');
        cmp.set("v.enduser",'');
        cmp.set("v.reseller",'');
        cmp.set("v.industry",'');
        cmp.set("v.family",'');
	},
    pupdate : function(cmp, event, helper) {
        //show the spinner. Get values from both 
        //opportunities and line items
        //update both and give results
        //once results are succesful, then remove spinner
        helper.spinnershow(cmp, event,helper);    
        var opps = cmp.get("v.opportunities");
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
                          "lines" : olines,
                          "product" : cmp.get("v.product")});
        action.setCallback(this, function(data) {
        var rslt = data.getState();
       		if (rslt === "SUCCESS"){
            	helper.myAction(cmp, event,helper);
            }else{
                helper.myAction(cmp, event,helper);
                alert('There were some errors on the save');
            }
        });
        $A.enqueueAction(action);
	},
    toggle: function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    deleteprod: function (cmp, event,helper) {
       helper.spinnertoggle(cmp, event,helper);
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
                helper.myAction(cmp, event,helper);
                    
            }else{
                 //refresh the searches post delete  
                helper.myAction(cmp, event,helper);   
                alert('There were some errors on the delete');
            }
        });
        $A.enqueueAction(action);
       
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
    inputlook : function(component, event, helper) {
    var evt = $A.get("e.force:navigateToComponent");
    evt.setParams({
        componentDef : "c:PiplelineTest",
        componentAttributes: {
            contactName : 'Johnny Tester'
        }
    });
    evt.fire();
	},
    lookup : function(component, event, helper) {
    console.log('ran');
    },
    displayOpportunities: function(component, event, helper) {
		//console.log($A.get("e.c:displayopp"));
		component.set("v.spaoppid" , event.getSource().get("v.value"));
        console.log(' oppid from button is '+ event.getSource().get("v.value"));
        console.log('attribute opp id is ' +component.get("v.spaoppid"));
		//var opp = event.getSource().get("v.value");
		//console.log(opp);
		var spas = $A.get("e.c:displayopp");
        //spas.setParams({ "oppId":  opp});
        spas.fire();
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
    followup: function(cmp, event, helper) {
		//var opps = event.getSource().get("v.value");
        var follow = $A.get("e.c:OppPipeFollowUp");
        //follow.setParams({ "opportunities":  opps});
        follow.fire(); 
    },
    createSpa : function (cmp, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        var opp = event.getSource().get("v.value");
        console.log(opp.Partner_Account_Search__c);
        //checking country of user to determine correct record type
        //so the correct pricebook options show
        var u = cmp.get("v.user");
        console.log('userid and country');
        //set variables for country and channel pricing
        var recid = '';
        var country = '';
        if(u.Country == 'United States'){
            recid= '012180000004bhP';
            country = 'United States'
        }else if(u.Country == 'Canada'){
            recid= '012180000004bjz';
            country = 'Canada'
        }else{
            recid= '012180000004bk4';
            country = 'Latin America'
        }
        
        console.log(opp);
        //need to set record types based on user profile
        //so the correct pricebooks show
        createRecordEvent.setParams({
            "entityApiName": "Opportunity", 
            "recordTypeId" : recid,
            "defaultFieldValues": {
                'StageName' : 'Price Request',
                'End_User_Lookup_Account__c' : opp.AccountId,
                'AccountId' : opp.AccountId,
                'Name' : 'SPA '+opp.Account.Name,
                'Partner_Account_Search__c' : opp.Partner_Account_Search__c,
                'ResellerContact__c' : opp.ResellerContact__c,
                'End_User_Contact__c' : opp.End_User_Contact__c,
                'Trade_Show_or_Marketing_Campaign__c' : opp.Trade_Show_or_Marketing_Campaign__c,
                'CloseDate' : opp.CloseDate,
                'Opportunity_Notes__c' : opp.Opportunity_Notes__c,
                'SpaCreateFOpp__c' : opp.Id,
                'Country__c' : country
            }
        });
        createRecordEvent.fire();
  },
    viewopp : function(cmp,event,helper){
        console.log(event);
        var opp = event.getSource().get("v.value");
        console.log('oppid '+opp);
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": opp
        });
        navEvt.fire();
    },
    enterkey : function(cmp,event,helper){
       if (event.keyCode === 13) {
           helper.myAction(cmp, event,helper);
		} 
    }
})