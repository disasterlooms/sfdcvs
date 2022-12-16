({
    handleClick : function(cmp, event, helper) {
      helper.showSpinner(cmp,event,helper);
      console.log('get searchtext');
      //var cat = 'promos,Sell Sheets';
      var catType = event.getSource().get("v.id");
        if(catType){
            cmp.set("v.category",catType);
        }
      var cat = cmp.get("v.category");
      console.log('cat '+cat);
      var searchText = cmp.get('v.searchText');
      console.log(searchText);  
      let quant = cmp.get("v.qty");
      let excl = cmp.get("v.exclusion");  
      let lib =cmp.get("v.library");  
      let channelProgams = cmp.get("v.channelPrograms");
      if(!channelProgams){
        let action = cmp.get('c.searchForIds');
        action.setParams({searchText: searchText,
                          qty : quant,
                          exclusion : excl,
                          library : lib,
                          category : cat
                          
                         });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          var ids = response.getReturnValue();
            console.log('ids of success');
            console.log(ids[0]);
            console.log(ids);
            let id1 = ids[0];
            //component.set("v.fileId",id1);
            //console.log('value test '+component.get("v.fileId"));
            cmp.set("v.files",ids);
            if(ids.length == 0){
               cmp.set("v.resutsFound",false); 
            }else{
                cmp.set("v.resutsFound",true); 
            }
            helper.hideSpinner(cmp,event,helper);
                
        }else{
            console.log('there was an error, need better error reporting');
            helper.hideSpinner(cmp,event,helper);
            var errors = response.getError();  
            console.log(errors[0].message);
        }
      });
      $A.enqueueAction(action);

      }else{
        //let action = cmp.get('c.getPromos');
        let action = cmp.get('c.getPromos');
        let spiffsB = cmp.get("v.spiffs");
        let pricingB = cmp.get("v.pricing");
        let promosB = cmp.get("v.otherPromos");

        action.setParams({
                          qty : quant,
                          spiffs : spiffsB,
                          promos : pricingB,
                          pricing : promosB                          
                         });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          var ids = response.getReturnValue();
            console.log('ids of success');
            console.log(ids[0]);
            console.log(ids);
            let id1 = ids[0];
            //component.set("v.fileId",id1);
            //console.log('value test '+component.get("v.fileId"));
            cmp.set("v.files",ids);
            if(ids.length == 0){
               cmp.set("v.resutsFound",false); 
            }else{
                cmp.set("v.resutsFound",true); 
            }
            helper.hideSpinner(cmp,event,helper);
                
        }else{
            console.log('there was an error, need better error reporting');
            helper.hideSpinner(cmp,event,helper);
            //var errors = response.getError();  
            //console.log(errors[0].message);
        }
      });
      $A.enqueueAction(action);
      }
      
    },
    keyCheck : function(cmp,event,handler){
        //console.log('kepress');
    },    
    flowNextScreen : function(cmp,event,handler){
        let nxt = cmp.get("v.flownxtpg");
        if(nxt){
            var navigate = cmp.get("v.navigateFlow");
            navigate("NEXT");
        }        
    },
    hideSpinner : function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    showSpinner : function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    }
})