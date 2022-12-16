({
    myAction : function(cmp, event, helper) {
        var ls = localStorage.getItem('modalOpenOrder');
        console.log(ls);
        
        var lsTime = localStorage.getItem('modalOpenOrderTime');
        console.log(lsTime);
        var ts = Math.round(new Date().getTime() / 1000);
        
        //localStorage.setItem('modalOpenOrder', 'true');
        
        //localStorage.setItem('modalOpenOrderTime', ts - (23 * 3600));
        
        var ls = localStorage.getItem('modalOpenOrder');
        console.log(ls);
        
        
        if(ls){
            if(ls == 'true'){
                if(ts){
                    if(ts > lsTime){
                        helper.showModal(cmp,event,helper);
                        console.log('show time exist and stamp is greater than delay');
                    }
                    
                }else{
                    helper.showModal(cmp,event,helper);
                    console.log('show');
                }
                
            }else{
                console.log('there is a value');
                console.log('ls val '+ls); 
            }    
            
            
        }else{
            console.log('no value');
            helper.showModal(cmp,event,helper);
            
            // show the modal if no value
            // And set the date
            
            
        }
        console.log(ls);
        console.log('local st');
    },
    dismiss : function(cmp,event,helper){
        console.log('dismiss');
        helper.hideModal(cmp,event,helper);
        helper.dismissForever(cmp,event,helper);
        
    },
    later : function(cmp,event,helper){
        console.log('later');
        helper.hideModal(cmp,event,helper);
        helper.dismissToday(cmp,event,helper);
        
    }
})