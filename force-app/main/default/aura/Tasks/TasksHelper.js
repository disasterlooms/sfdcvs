({
    helperMethod : function() {
        
    },
    toggleClass: function(cmp,componentId,className) {
        var modal = cmp.find(componentId);
        $A.util.removeClass(modal,className+'hide');
        $A.util.addClass(modal,className+'open');
    },
    
    toggleClassInverse: function(cmp,componentId,className) {
        var modal = cmp.find(componentId); 
        $A.util.addClass(modal,className+'hide');  
        $A.util.removeClass(modal,className+'open');
    },
    toggle: function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    gettasks : function(cmp,event,helper){
        
        var settings = cmp.get("c.getUser");
        settings.setCallback(this, function(data){
            var set = data.getReturnValue();
            if(set){
                cmp.set("v.settings", set);
                
            }
            
            console.log('set for tasks');
            console.log(set);
            console.log(data.getReturnValue());
            var today = new Date();
            today.setHours(today.getHours() - 8);
            console.log('now '+today.toISOString());
            console.log('first date befor change');
            console.log('minus 1 '+today.toISOString().slice(0, 10));
            today = today.toISOString().slice(0, 10);
            console.log('today');
            console.log($A.localizationService.formatDateUTC(today, "YYYY-MM-DD Z"));
            if(set){
                console.log('date act ' +set.ActivityReminders__c);
                
                
                
                if(set.ActivityReminders__c  != today || set.ActivityReminders__c  == null || set.ActivityReminders__c  == 'undefined'){
                    //helper.toggle(cmp,event,helper);
                    var tasks = cmp.get("c.activities");
                    tasks.setParams({"whereclause" : ''});
                    tasks.setCallback(this, function(data){
                        var reminders = data.getReturnValue();
                        
                        
                        if(reminders.length >0){
                            cmp.set("v.tasks", data.getReturnValue());
                            cmp.set("v.selectedtask",reminders[0].Id);
                            console.log(reminders.length);
                            console.log('reminders');
                            console.log(reminders);                        
                            var recid = reminders[0].Id;
                            //helper.editcomp(cmp,event,helper,recid);
                            helper.toggleClass(cmp,'backdrop','slds-backdrop--');
                            helper.toggleClass(cmp,'modaldialog','slds-fade-in-');
                            
                        }else{
                            console.log(reminders.length);
                            console.log('reminders');
                        }
                        
                    });
                    $A.enqueueAction(tasks);
                }else{
                    console.log('is not today date');
                }
            }
        });
        $A.enqueueAction(settings);
        
    },
    editcomp : function(cmp,event,helper,recid){
        helper.toggle(cmp,event,helper);
        $A.createComponent('force:recordEdit',
                           {
                               'aura:id': 'edit',
                               'recordId': recid
                           },
                           function(edit){
                               cmp.set('v.edit', edit);
                           }
                          );
        
    }
    
})