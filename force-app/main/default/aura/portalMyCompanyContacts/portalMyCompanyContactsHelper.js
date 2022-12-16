({
	searchFun : function(cmp,event,helper) {
		var names = cmp.get("v.unfilteredContacts");
        var searchKey = cmp.get("v.searchWord");
        var filtereddata = names.filter(word => (!searchKey) || word.conName.toLowerCase().indexOf(searchKey.toLowerCase()) > -1);          
        var cons;
        if(searchKey){
            cons = filtereddata;
            cmp.set("v.contacts",filtereddata);
        }else{
            cons = names;
        }
        cmp.set("v.contacts",cons);
       
        if(cons.length == 0){
            cmp.set("v.showCons",false);
            console.log(cons.length);
            console.log('short');
        }else{
            cmp.set("v.showCons",true);
        }
        console.log('newName');
        console.log(searchKey);
        helper.removeSpinner(cmp,event,helper);
	},
    removeSpinner: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    showSpinner: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    }
})