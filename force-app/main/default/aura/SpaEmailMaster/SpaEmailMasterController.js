({
    myAction : function(cmp, event, helper) {
        
    },
    getMessages : function(cmp, event, helper) {
        helper.getmssgs(cmp, event,helper);
        console.log('getMessages');        
    },
    enterkey : function(cmp,event,helper){
        console.log('enter ');
        console.log(event.keyCode);
        if (event.keyCode === 13) {
            helper.getmssgs(cmp, event,helper);
        } 
    }
})