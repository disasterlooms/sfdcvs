({ 
    init: function(cmp,event,helper){
        helper.accessCheck(cmp, event, helper);
    }, 
    startflow : function (cmp,event,helper) {
        if(cmp.get("v.shippingconfirmationPage")||
        cmp.get("v.confirmationPage")){
            return;
        }
        helper.spinner(cmp, event, helper);
        console.log('updating');
        //debugger;
        var checkboxes = cmp.find("DependentCheckboxpart");
        console.log(' checked boxes');
        console.log(checkboxes);
        //Prasad: Added CheckBox for Select Special Price
        var splckboxes = cmp.find("selectsplprice");
        var records = cmp.get("v.records");
        //console.log(checkboxes);           
        var prods = [];
        var i;
        console.log('loop through checkboxes');
        console.log(records);
        
        // Prasad: Adding If condition to check if there is only 1 record for Eval Unit Details
        //debugger;
        if(checkboxes.length == undefined ){
            //debugger;
            var specialprice = 0;
            var overwrite = false;
            //jason orbi: need to check if the price is not undefined and over 0 in order to 
            //set the overwrite field to true, thus removing an extra inmaterial field from the 
            //users page. 
            
            if(records[0].Special_Eval_Price__c != undefined){
                if(records[0].Special_Eval_Price__c > 0){
                    overwrite = true; 
                }                
                specialprice = records[0].Special_Eval_Price__c;
            }
            
            console.log('get special price');
            console.log(specialprice);
            console.log(overwrite);
            
            var id = checkboxes.get("v.name");
            prods.push({'sobjectType':'Eval_Unit_Details__c','Id': id,
                        Special_Eval_Price__c: specialprice,
                        Use_Special_Price__c:overwrite,
                        Eval_Quote__c : cmp.get("v.quoteid")});
            
        }else{
            for (var i = 0; i < checkboxes.length; i++){
                console.log('value of checkbox');
                //orbison: After getting selected products, will search the
                //eval units array using map function on the Id column to get the
                //singular object in the array and then get special price
                //or any other field in that object later (if needed) and send to 
                //the server side controller. The user needs to update special price field each
                //time they decide to create a quote if they want to override or change override price
                
                if(checkboxes[i].get("v.checked") == true){
                    console.log(checkboxes.length);
                    console.log('lenght');
                    var id = checkboxes[i].get("v.name");
                    //var j = records.indexOf(id,0);
                    var elementPos = records.map(function(x) {
                        return x.Id; }).indexOf(id);
                    var j = records[elementPos];
                    /*
                    console.log('index of reocrds');
                    console.log(elementPos);
                    console.log('the overwrite price');
                    console.log(j.Special_Eval_Price__c);
                    */
                    prods.push({'sobjectType':'Eval_Unit_Details__c','Id': id,
                                Eval_Quote__c : cmp.get("v.quoteid"),
                                Special_Eval_Price__c : j.Special_Eval_Price__c,
                                Use_Special_Price__c: true
                                
                               });
                    console.log(prods);
                    console.log('quote id');
                } 
            }
            
            /*
            for (var i = 0; i < checkboxes.length; i++){
                var splpriceval=0;
                var overwrite = false;
                //debugger;
                //console.log('value of checkbox');
                if(checkboxes[i].get("v.checked") == true){
                    
                    //console.log(checkboxes.length);
                    //console.log('lenght');
                    var id = checkboxes[i].get("v.name");
                    //Prasad: if check box is checked 
                    
                    if(splckboxes != undefined){                   
                        for (var k = 0; k < splckboxes.length; k++){
                            //debugger;
                            if(splckboxes[k].get("v.checked") == true && checkboxes[i].get("v.name") == splckboxes[k].get("v.name")){
                                //Prasad: get spl price value
                                
                                for(var j=0; j<records.length; j++){
                                    //debugger;
                                    if(records[j].Id == splckboxes[k].get("v.name")){
                                        splpriceval = records[j].Special_Eval_Price__c;
                                    }
                                }
                            }                    
                        }
                    }
                    
                    if(splpriceval !=0){
                        prods.push({'sobjectType':'Eval_Unit_Details__c','Id': id,
                                    Special_Eval_Price__c:splpriceval,
                                    Use_Special_Price__c:true,
                                    Eval_Quote__c : cmp.get("v.quoteid")});
                    }else{
                        prods.push({'sobjectType':'Eval_Unit_Details__c','Id': id,
                                    Eval_Quote__c : cmp.get("v.quoteid")});
                        
                    }
                    
                    
                    console.log(prods);
                    console.log('quote id');
                } 
            }
             */
        }
        
        console.log(prods.length);
        console.log('length of the prods check');
        
        if(prods.length == 0){
            if(records.length > 1){
                alert('Please Select at Least 1 Product');
                return;
            }else{
                var id = checkboxes.get("v.name");
                prods.push({'sobjectType':'Eval_Unit_Details__c','Id': id,
                Eval_Quote__c : cmp.get("v.quoteid")});
            }           
            
        }
        var actname = cmp.get("v.actname");
        console.log('name of controller method '+actname);
        var action = cmp.get("c."+actname);
        console.log('udpated name of action '+action);
        //console.log(cmp.get("v.quoteid"));
        //console.log('quote id for units');
        //console.log('check units');
        //console.log(prods);
        //helper.tablehide(cmp,event,helper);
        var quoteid = cmp.get("v.quoteid");
        console.log(' here is quote id '+quoteid);
        if(quoteid != null && quoteid != '' && quoteid != undefined  ){
            action.setParams({"units":  prods,
                              "quoteId" : quoteid
                             });
            console.log('there is a quote id');
        }else{
            action.setParams({"units":  prods
                             });
            console.log('no quote id');
        }
        
        
        
        action.setCallback(this, function(data) {
            //debugger;
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                console.log('units update succesful');
                helper.spinner(cmp, event, helper);
                if(cmp.get("v.flowRun")){
                    console.log('flow handler ran and it should not go to flow');
                    var navigate = cmp.get('v.navigateFlow');
                    navigate("NEXT");
                }else{
                    console.log('flow run should not be here')
                    helper.flow(cmp,event,helper);
                }
                
            }else{
                helper.spinner(cmp, event, helper);
                alert('There was an error with the eval units, please notify admint');
                console.log(rslt.getError()); 
            }
        });
        $A.enqueueAction(action); 
    },
    returnflow : function(cmp,event,helper){
        //debugger;
        console.log('return event');
        helper.flow(cmp,event,helper);
    },
    flowComplete : function(cmp,event,helper){
        //debugger;
        var status = event.getParam("status");
        console.log('this has changed');
        console.log(status);
        if( status === "FINISHED") {
            cmp.set("v.completed" , true);
            
        }
        
        
    },
    flowPrev : function(cmp,event,helper){
        var navigate = cmp.get('v.navigateFlow');
        navigate("BACK");
    }
})