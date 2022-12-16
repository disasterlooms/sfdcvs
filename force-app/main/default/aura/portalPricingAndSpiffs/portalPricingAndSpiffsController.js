({
    myAction : function(cmp, event, helper) {
        var flow = cmp.find("flowData");
       flow.startFlow("pp_getUserInfoLightningCmp");
        
        var admin = cmp.get("v.adminSearch");
        console.log('admin Search ? '+ admin);
        if(admin){
            helper.getAdminRecords(cmp,event, helper);
            console.log('admin getting spiff amounts ');
        }else{
            helper.getRecords(cmp,event, helper); 
            console.log('user getting spiff amounts ');
        }
    },
    searchk : function(cmp,event,helper){
        
        console.log('para');
        console.log(cmp.get("v.search"));
        console.log(event.getParams());
        
        var admin = cmp.get("v.adminSearch");
        console.log('admin Search ? '+ admin);
        if(event.getParams().keyCode == 13){
            console.log('search');
            helper.toggle(cmp, event,helper);
            if(admin){
                helper.getAdminRecords(cmp,event, helper);
                console.log('admin getting spiff amounts ');
            }else{
                helper.getRecords(cmp,event, helper); 
                console.log('user getting spiff amounts ');
            }
            
        }
    },
    search : function(cmp,event,helper){
        helper.toggle(cmp, event,helper);
        console.log('search');
        console.log('para');
        console.log(cmp.get("v.search"));
        console.log(event.getParams());
        helper.getRecords(cmp, event, helper); 
    },
    handleKeyUp: function (cmp, evt,helper) {
        var admin = cmp.get("v.adminSearch");
        var isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            console.log('search');
            helper.showSpinner(cmp,event,helper); 
            if(admin){
                helper.getAdminRecords(cmp,event, helper);
                console.log('admin getting spiff amounts ');
            }else{
                helper.getRecords(cmp,event, helper); 
                console.log('user getting spiff amounts ');
            }
        }
    },
    handleStatusChange : function (cmp, event) {
        console.log('cchnge flow '+ event.getParam("status"));
      if(event.getParam("status") === "FINISHED_SCREEN") {
         // Get the output variables and iterate over them
         var outputVariables = event.getParam("outputVariables");
         var outputVar;
          console.log('finished');
         for(var i = 0; i < outputVariables.length; i++) {
            outputVar = outputVariables[i];
             console.log('output var names '+outputVar.name);
            // Pass the values to the component's attributes
            if(outputVar.name === "country") {
               cmp.set("v.userCountry", outputVar.value);
               var country =  outputVar.value;
                console.log('country + '+country);
                if(country == 'Canada'){
                    cmp.set("v.currency",'CAN');
                    
                }
            } 
             if(outputVar.name === "contactRecord") {
               cmp.set("v.conRecord", outputVar.value);
            } 
         }
      }
        var spinner = cmp.find("flowData");
        $A.util.addClass(spinner,"slds-hide");
   },
})