({
	
    etype : function(cmp, event, helper) {
		console.log('runnign etyp');
        var action = cmp.get("c.getTypes");
        action.setParams({"trade": cmp.get("v.trade")
                       });
        action.setCallback(this, function(data) {
        cmp.set("v.etype", data.getReturnValue());
        console.log(cmp.get("c.etype"));
        });
        $A.enqueueAction(action);
	},
    type : function(cmp, event, helper) {
     var type = cmp.get("v.type");
     var trade = cmp.get("v.trade");
     console.log('type '+type);  
        if(type == '' || type =='--None--'){
            alert("Please select Eval Type");
        }else{            
           //$A.get("this.e.force:closeQuickAction").fire();
            var reqtype = $A.get("e.force:closeQuickAction");
            
            try{
                reqtype.fire();
                helper.neweval(cmp, event, helper,type);
            }catch(err){
                helper.neweval(cmp, event, helper,type);
            }
            //reqtype.fire();
            //console.log(reqtype);
            //console.log('requ1');
            
            
            /*
             * 
             * this.superAfterRender();
            window.setTimeout(
                $A.getCallback(function () {
                    $A.get("e.force:closeQuickAction").fire();
                }), 500
            );
            
            setTimeout(function(){
                
                console.log('type: ' +type);
                console.log('cmp: ' +cmp);                
                console.log('event: ' +event);
                
                console.log('helper: ' +helper);
                              
            }, 25);
             */ 
            
            //reqtype.fire();
            
        }
    },
    trade : function(cmp,event,helper){
      var trade = cmp.get("v.trade");
      var action = cmp.get("c.getTypes");
      console.log(trade);
      action.setParams({"trade": cmp.get("v.trade")
                       });
        if(trade == true){
            cmp.set("v.tradeinfo", true);
            action.setCallback(this, function(data) {
            cmp.set("v.etype", data.getReturnValue());
            });        
        }else{
            cmp.set("v.tradeinfo", false);
            action.setParams({"trade": cmp.get("v.trade")
                         });
            action.setCallback(this, function(data) {
            cmp.set("v.etype", data.getReturnValue());
            }); 
        }
        $A.enqueueAction(action);
    },
    showhelp : function(cmp,event,helper){
        cmp.set("v.help", true);
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:EvalTypeHelpModal"
        });
        evt.fire();
    }
   
    
})