({
    myAction : function(cmp,event,helper) {
        helper.addspinner(cmp,event,helper);
        console.log('init running');
        var action = cmp.get("c.getAccount");
        console.log(cmp.get("v.custid")+' recid ');
        action.setParams({
            "recid" : cmp.get("v.custid")
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                    
                cmp.set("v.account",resp.getReturnValue());
                var act = resp.getReturnValue();
                var ind = act.Industry;
                console.log('industry');
                console.log(ind);
                
                
                if(ind.includes("Education")){
                    cmp.set("v.headertype","Education");
					cmp.set("v.imageUrl","https://www.viewsonic.com/skin/frontend/smartwave/viewsonic/images/solutions/education/interactive-learning-banner.jpg");
                    
                    
                }else if(ind.includes("Government")){
                    cmp.set("v.headertype","Government");
                    cmp.set("v.imageUrl","https://www.viewsonic.com/media/contenttype/articles/Conference-Room.jpg");
                    
                }else{
                    cmp.set("v.headertype","Customer");
                    cmp.set("v.imageUrl","https://www.viewsonic.com/media/contenttype/articles/Conference-Room.jpg");
                }
                
                
                
                cmp.set("v.accNotFound",false);
                cmp.set("v.recordId",resp.getReturnValue().Id);
                helper.gettingCons(cmp,event,helper);
                helper.removespinner(cmp,event,helper);
                
            }
            else{
                // alert(resp.getError());
                console.log('error gettin acct info');
                console.log(resp.getError());
                helper.removespinner(cmp,event,helper);
                helper.toasterrorAcct(cmp,event,helper);
            }
        });
        $A.enqueueAction(action);
    },
    toastconAdd : function(cmp,event, helper){
        helper.toast(cmp,event,helper);        
    },
    orderCreated : function(cmp,event,helper){
        console.log('parent has the event');
        var orderChangeVal = cmp.get("v.orderChange");
        if(orderChangeVal == true){
            cmp.set("v.orderChange",false);
        }else{
             cmp.set("v.orderChange",true);
        }
    }
 })