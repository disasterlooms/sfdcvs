({
	myAction : function(component, event, helper) {
		helper.spinner(component, event, helper);
        var getuser = component.get("c.getId");        
        getuser.setCallback(this, function(data) {
        component.set("v.userid", data.getReturnValue());
        });        
        $A.enqueueAction(getuser);
	},
    refresh : function(component, event, helper){
        console.log('refresh');
        //cmp.find("test").reloadRecord();
    },
    saveCase : function(component, event, helper) {
        helper.spinner(component, event, helper);
        var fils = component.get("v.files");
        var docid = '';
        if(fils != null){
            docid = fils[0].documentId;
            console.log(fils);
            console.log(docid);
        }       
        var update = component.get("c.updateRecords");   
        update.setParams({"whatdoing": component.get("v.what"),
                          "wherepage": component.get("v.where"),
                          "docid": docid,
                          "subject": "lightning error",
                          "mssg" : component.get("v.mssg"),
                          "recid" :  component.get("v.recordId")
                         });
        update.setCallback(this, function(data) {
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({                    
                    "message": "Admin has been notified and will let you know when issue is resolved. Thanks for the feedback.",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
                var utilityAPI = component.find("utilitybar");
                utilityAPI.minimizeUtility();
                component.set("v.what", null);
                component.set("v.mssg", null);
                component.set("v.where", null);
                helper.spinner(component, event, helper);
            }else if(rslt === "ERROR"){
                 helper.spinner(component, event, helper);
                 console.log('error '+JSON.stringify(data.error));
            }
        });        
        $A.enqueueAction(update);
    },
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        //var docid = event.getParam("documentId");
        //console.log(docid);
        console.log(uploadedFiles);
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
                    "message": "File Uploaded",
                    "type" : "success",
                    "key" : "approval"
                });
                resultsToast.fire();
        
        console.log(uploadedFiles);
        cmp.set("v.files", uploadedFiles );
    }
})