({
    getRecords : function(cmp, event, helper) {
        helper.toggle(cmp, event,helper);
        console.log('parent id '+cmp.get("v.parentid"));
        var records = cmp.get("c.getRecords");
        var likestmt = 'and '+cmp.get("v.searchfield") +' like  \'%' + cmp.get("v.search")  + '%\'';
        records.setParams({"wherestmt" : cmp.get("v.wherestmt"),
                          "limitstmt" : cmp.get("v.limitstmt"),
                          "orderstmnt" : cmp.get("v.orderstmnt"),
                          "obj" : cmp.get("v.objToQuery"),
                          "searchtxt" : likestmt,
                           "addfields" : cmp.get("v.addfields"),
                           "parentid" : cmp.get("v.parentid")});
        records.setCallback(this,function(data){
           cmp.set("v.records" , data.getReturnValue());
           console.log('data return');
           console.log(cmp.get("v.records"));
           helper.hideSpinner(cmp, event,helper);
        });
        $A.enqueueAction(records);
        var cmpTarget = cmp.find('selections');
        $A.util.addClass(cmpTarget, 'slds-input_bare');
        
		
	},
    toggleClass: function(cmp,componentId,className) {
        var modal = cmp.find(componentId);
        $A.util.removeClass(modal,className+'hide');
        $A.util.addClass(modal,className+'open');
    },
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    hideSpinner : function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    }
})