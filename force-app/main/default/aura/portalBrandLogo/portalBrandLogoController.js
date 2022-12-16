({
    myAction : function(cmp, event, helper) {
        //helper.hideSpinner(cmp,event,helper);
        //cmp.set("v.testImageUrl",'https://partner.viewsonic.com/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=0681H00000JOynw&operationContext=CHATTER');
    },
    handleUploadFinished : function(cmp,event,helper){
        helper.showSpinner(cmp,event,helper);
        var files = event.getParam("files");
        //alert("Files uploaded : " + uploadedFiles.length);
        console.log(files[0].documentId);
        cmp.set("v.docId", files[0].documentId);
        console.log('files fileds');
        console.log(files[0]);
        cmp.set("v.docName",files[0].name);
        //console.log('files[0].Name '+files[0].name);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: 'success',
            title : "File "+files[0].name+ " was added successfully",
            message: 'Please ensure the payment type is correct, and the click Submit for Review'
        });
        toastEvent.fire();
        var navigate = cmp.get('v.navigateFlow');
        navigate("NEXT");
        helper.hideSpinner(cmp,event,helper);
        cmp.set("v.btnDisabled",false);
        //helper.updateImage(cmp,event,helper);
        
    },
    onButtonPressed: function(cmp, event, helper) {
        var navigate = cmp.get('v.navigateFlow');
        navigate("NEXT");
    },
    previous: function(cmp, event, helper) {
        var navigate = cmp.get('v.navigateFlow');
        navigate("BACK");
    },
    clickfound : function(cmp,event,helper){
        console.log('was there a click?');
    }
    
})