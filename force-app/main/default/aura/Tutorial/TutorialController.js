({
	myAction : function(cmp, event, helper) {
        var settings = cmp.get("c.getUser");
        //localStorage.setItem('myCat', 'Tom');
        var ls = localStorage.getItem('modalShow');
        if(ls){
            console.log('there is a value');
        }else{
            console.log('no value');
        }
        console.log(ls);
        console.log('local st');
        
        settings.setCallback(this, function(data){
            var set = data.getReturnValue();
            console.log(set);
            console.log('set');
            if(set){
                console.log('not null');
                cmp.set("v.settings", set);
            }
            
           
            //console.log(data.getReturnValue());
            var today = new Date();
            console.log('now '+today);
            console.log('first date befor change');
            console.log('minus 1 '+today.toISOString().slice(0, 10));
            today = today.toISOString().slice(0, 10);
            console.log('today');
            console.log(today);
            if(set.Date__c == today || set.Date__c == null || set.Date__c == 'undefined' || set.Never__c == true || set.Counter__c > 2){
            }else{
                console.log('is not today date');
                helper.toggleClass(cmp,'backdrop','slds-backdrop--');
        		helper.toggleClass(cmp,'modaldialog','slds-fade-in-');
            }
        });
        $A.enqueueAction(settings);
        
    },
    hideModal : function(cmp, event, helper) {
		 //Toggle CSS styles for hiding Modal
		helper.toggleClassInverse(cmp,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(cmp,'modaldialog','slds-fade-in-');
	},
    dismiss : function(cmp,event, helper){
        cmp.set("v.settings.Never__c" , true); 
        helper.update(cmp,event,helper);
    },
    later : function(cmp,event, helper){
        helper.update(cmp,event,helper);
    }
})