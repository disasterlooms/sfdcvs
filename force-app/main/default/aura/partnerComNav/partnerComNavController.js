({
    myAction : function(cmp, event, helper) {
        
    },
    onClick : function(cmp,event,helper){
        var action = cmp.get("v.onClicktype");
        if(action == 'quote'){
            helper.newDeal(cmp,event,helper);
        }else if(action == 'search'){
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/currentdeals"
            });
            urlEvent.fire();
            
        }if(action == 'orders'){
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/orders"
            });
            urlEvent.fire();
        }if(action == 'Contact Request'){
            helper.newRequest(cmp,event,helper);
        }
        console.log('cs create contact act typ '+action);
        if(action == 'Contact'){
            console.log('cs create contact ');
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/admin/s/createrecord/NewContact"
            });
            urlEvent.fire();
            //helper.newContact(cmp,event,helper);
        }
    },
    
    productSpecs : function(cmp,event,helper){
        
    },
    
    findSpa : function(cmp,event,helper){
        
    },
    
})