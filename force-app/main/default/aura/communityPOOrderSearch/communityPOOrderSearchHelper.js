({
	getPOInfo : function(cmp,event,helper) {
        
        helper.showspinner(cmp,event,helper);
        var action = cmp.get("c.getCalloutResponseContents");
        // set the url parameter for getCalloutResponseContents method (to use as endPoint) 
        //var base = 'USD';
        var po = cmp.get("v.ponumber");
        console.log('num cmp');
        console.log(cmp.get("v.ponumber"));
        
        console.log('ponu '+po);
        action.setParams({
            "url": 'https://viewapps.viewsonic.com/OrderStatus/poStatus.php?po='+po
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                // set the response(return Map<String,object>) to response attribute.      
                var dta = response.getReturnValue();
                var parsed = JSON.parse(dta);
                
                console.log(dta);
                console.log('the data');
                //console.log(parsed);
                //console.log(parsed[0].lines);
                cmp.set("v.pos", parsed);
                console.log(parsed);
                
                /*
                
                var results = parsed.search_results;
                console.log('results');
                console.log(parsed);
                
                cmp.set("v.parsed", parsed);
                console.log('get data');
                console.log(parsed[0].po_number);
                */
                helper.hidespinner(cmp,event,helper);
                cmp.set("v.disabled",false);
                
                
                
                
            }else{
                helper.hidespinner(cmp,event,helper);
                alert('there was an error, please let admin know');
                cmp.set("v.disabled",false);
                
            }
        });
 
        $A.enqueueAction(action);
		
	},
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinnerspa");
        $A.util.toggleClass(spinner, "slds-hide");
    },
     hidespinner : function(cmp, event, helper) {
        //Toggle CSS styles for hiding Modal
        var cmpTarget = cmp.find("mySpinnerspa");
        $A.util.addClass(cmpTarget, 'slds-hide');        
        
    },
    showspinner : function(cmp, event, helper) {
        //Toggle CSS styles for hiding Modal
        var cmpTarget = cmp.find("mySpinnerspa");
        $A.util.removeClass(cmpTarget, 'slds-hide');        
        
    },
})