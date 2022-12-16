({
    myAction : function(cmp, event, helper) {   
        
        helper.getRecords(cmp, event, helper); 
    },
    searchk : function(cmp,event,helper){
        if(event.getParams().keyCode == 13){
            helper.showSpinner(cmp,event,helper);
            console.log('enter key get records helper');
            helper.getRecords(cmp,event, helper); 
        }
    },
    search : function(cmp,event,helper){
        console.log('click of button get records helper');
        //helper.toggle(cmp, event,helper);
        helper.showSpinner(cmp,event,helper);
        helper.getRecords(cmp, event, helper); 
    },
    
    select : function(cmp,event,helper){
         var spaSelected = event.getSource().get("v.name");
         cmp.set("v.spaId",spaSelected);
        var navigate = cmp.get('v.navigateFlow');
        navigate("NEXT");
        
    }
})