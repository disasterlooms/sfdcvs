({
	helperMethod : function() {
		
	},
     showSpinner: function (cmp, event,handler) {
        var spinner = cmp.set("v.toggleClass","");
    },
    hideSpinner: function (cmp, event,handler) {
        var spinner = cmp.set("v.toggleClass","slds-hide");
    },
    getBilling : function(cmp,event,helper){
        helper.showSpinner(cmp,event,helper);
        var accb = cmp.get("v.billCon");
        // checking for billing contacts missing demographics
        var bcon = cmp.get("c.checkBilling");
        bcon.setParams({"billing": accb
                       });        
        bcon.setCallback(this, function(data) {
        cmp.set("v.bcon", data.getReturnValue());
        console.log('billin con boolean returned');
        console.log(data.getReturnValue());
        helper.getShipping(cmp,event,helper);
        });        
        $A.enqueueAction(bcon);
        
       
    },
    getShipping : function(cmp,event,helper){
        var con =  cmp.get("v.shipCon");
        console.log(con+ ' shipping conid');
        
        var scondemos = cmp.get("c.checkShipping"); 
        scondemos.setParams({"shipping": con
                       });
        scondemos.setCallback(this, function(data) {
            cmp.set("v.scon", data.getReturnValue());

       console.log('shipping con boolean returned');
        console.log(data.getReturnValue());
        helper.hideSpinner(cmp,event,helper);
        });        
        $A.enqueueAction(scondemos);
        console.log(cmp.get("v.scon"));
    }
})