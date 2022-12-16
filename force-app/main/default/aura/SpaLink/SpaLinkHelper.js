({
    toggleClass: function(component,componentId,className) {
        var modal = component.find(componentId);
        $A.util.removeClass(modal,className+'hide');
        $A.util.addClass(modal,className+'open');
    },
    toggleClassInverse: function(component,componentId,className) {
        var modal = component.find(componentId); 
        $A.util.addClass(modal,className+'hide');  
        $A.util.removeClass(modal,className+'open');
    },
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinnerspa");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    getrelatedspa : function(cmp,event){
        //get the opportunity object field values
        //to send the accountid to the server side controller
        //var oppid = event.getParam("oppId");
        cmp.set("v.load", true);
        cmp.set("v.quotes", null);
        console.log('spa link starting to get related spas test');       
        if(cmp.get("v.recordId") === null || cmp.get("v.recordId") === undefined || cmp.get("v.recordId") === ''){
            console.log('no oppid');
            return;
        }        
        console.log('oppid is spaoopid blanks '+cmp.get("v.recordId"));
        //var oppaction = cmp.get("c.getOpp");
        //oppaction.setParams({"oppid": cmp.get("v.recordId")
                            //});
        //oppaction.setCallback(this, function(response) {
            //cmp.set("v.opportunity",response.getReturnValue());
            //var state1 = response.getState();
            //if (cmp.isValid() && state1 === "SUCCESS") {
                var action = cmp.get("c.getSpas");
                var ofields =  cmp.get("v.oppfields");
                var pfields =  cmp.get("v.prodfields");
                console.log('ofields');
                console.log(ofields);
                console.log('pfields');
                console.log(pfields);
                console.log('record id');
                console.log(cmp.get("v.recordId"));
                action.setParams({
                    "recid": cmp.get("v.recordId"),
                    "ofields": ofields,
                    "pfields": pfields            
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (cmp.isValid() && state === "SUCCESS") {
                        cmp.set("v.quotes",response.getReturnValue());
                        
                        cmp.set("v.load", false);
                        var load = $A.get("e.c:loading");
                        var opps = response.getReturnValue();
                        console.log('opps before event to load');
                        console.log(opps);
                        
                        var quotes = response.getReturnValue();
                        
                        var i =0;
                        
                        
                        for(var i = 0; i< quotes.length; i ++ ){
                           
                            cmp.set("v.oldquotes["+i+"].Id" ,quotes[i].Id);
                            cmp.set("v.oldquotes["+i+"].Resubmission_Notes__c" ,quotes[i].Resubmission_Notes__c);
                        }
                        
                        
                        
                        if(response.getReturnValue().length == 0){
                            cmp.set("v.nospas",true);
                        }
                        if(load != undefined){
                            load.setParams({ "quotes": opps });
                        	//fire the event to change loading outputtext
                        	load.fire();
                        }
                        
                    }else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            //$A.logf("Errors", errors);
                            if (errors[0] && errors[0].message) {
                                //$A.error("Error message: " +
                                //errors[0].message);
                            }
                        } else {
                            //$A.error("Unknown error");
                        }
                    }
                });
                $A.enqueueAction(action);
            //}
                
        //});
        //$A.enqueueAction(oppaction);
        
        var guser = cmp.get("c.getUser");        
        guser.setCallback(this, function(data) {
        cmp.set("v.user", data.getReturnValue());
        });        
        $A.enqueueAction(guser); 
    }
})