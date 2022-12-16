({
	helperMethod : function() {
		
	},
    hideSpinner : function(cmp,event,helper){
        cmp.set("v.spinnerClass","slds-hide");
    },
    showSpinner : function(cmp,event,helper){
        cmp.set("v.spinnerClass","");
    }
})