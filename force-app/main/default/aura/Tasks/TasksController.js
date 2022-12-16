({
    myAction : function(cmp, event, helper) {
        helper.gettasks(cmp,event,helper);
        console.log('task cmp');
    },
    hideModal : function(cmp, event, helper) {		
        //closes modal and update settings for user
        var task = cmp.get("c.updateTask");
        task.setParams({
            "settings" : cmp.get("v.settings")
        })
        task.setCallback(this,function(data){
            var rslt = data.getState();
       		if (rslt === "SUCCESS"){
                
            }else{
                
            }
        });        
        $A.enqueueAction(task);
        helper.toggleClassInverse(cmp,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(cmp,'modaldialog','slds-fade-in-');
	},
    delete : function(cmp,event,helper){
        helper.toggle(cmp,event,helper);
            var taskid = event.getSource().get("v.value");
            var tasktoDelete = cmp.get("c.deleteTask");
            tasktoDelete.setParams({
                "recordId" : taskid
            })
            tasktoDelete.setCallback(this,function(data){
                var rslt = data.getState();
                if (rslt === "SUCCESS"){
                    helper.toggle(cmp,event,helper);
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Deleted",
                        "message": "Task was Deleted Forever",
                        "type" : "success"
                    });
                    resultsToast.fire();
                    helper.gettasks(cmp,event,helper);
                }else{
                    helper.toggle(cmp,event,helper);
                    alert('there was an error, request assitance from admin ');
                    
                }
            });        
        $A.enqueueAction(tasktoDelete);
    },
    complete : function(cmp,event,helper){
        //console.log('complete started');
        helper.toggle(cmp,event,helper);
        var taskid = event.getSource().get("v.value");
        //console.log('record id '+taskid);
        var tasktoUpdate = cmp.get("c.TasktoUpdate");
        //console.log(tasktoUpdate);
        tasktoUpdate.setParams({
            "recordId" : taskid,
            "status" : true
        })
        tasktoUpdate.setCallback(this,function(data){
            var rslt = data.getState();
       		if (rslt === "SUCCESS"){
                helper.toggle(cmp,event,helper);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Saved",
                    "message": "Task Status Updated!",
                    "type" : "success"
                });
                resultsToast.fire();
                helper.gettasks(cmp,event,helper);
            }else{
                helper.toggle(cmp,event,helper);
                alert('there was an error, request assitance from admin ');
                
            }
        });        
        $A.enqueueAction(tasktoUpdate);
        
    },
    selected : function(cmp,event,helper){
        helper.toggle(cmp,event,helper);
        console.log('selected');
        var id = event.getSource().get("v.value");
        console.log('id '+id);
        console.log(event.getSource());
        $A.get('e.force:refreshView').fire();
        cmp.set("v.selectedtask",id);
        var recid = id;
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": id
        });
    editRecordEvent.fire();
        //helper.editcomp(cmp,event,helper,recid);
    },
    save : function(cmp, event, helper) {
        helper.toggle(cmp,event,helper);
        cmp.get("v.edit").get("e.recordSave").fire();
        //var saveRecord = cmp.find("edittask").get("e.recordSave");
    },
    handleSaveSuccess : function(cmp, event,helper) {       
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Saved",
            "message": "The record was saved.",
            "type" : "success"
        });
        resultsToast.fire();
        helper.gettasks(cmp,event,helper);
        helper.toggle(cmp,event,helper);
    }
})