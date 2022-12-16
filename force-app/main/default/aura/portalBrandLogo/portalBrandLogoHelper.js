({
    helperMethod : function() {
        
    },
    updateImage : function(cmp,event,helper){
       
        console.log('helper get url running');
        //helper.showSpinner(cmp,event,helper);        
        let docId =cmp.get("v.docId");  
        let action = cmp.get('c.getFileId');
        action.setParams({fileId: docId                          
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                let ids = response.getReturnValue();
                //console.log(ids);
                if(ids.length>0){
                   //cmp.set("v.doc",ids[0]);
                    //console.log(ids[0]);
                }
                
                helper.hideSpinner(cmp,event,helper);
                cmp.set("v.btnDisabled",false);
                
                
            }else{
                console.log('there was an error');
                //helper.hideSpinner(cmp,event,helper);
                var errors = response.getError();  
                console.log(errors[0].message);
                helper.hideSpinner(cmp,event,helper);
            }
        });
        $A.enqueueAction(action);
    },
    hideSpinner : function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    showSpinner : function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    }
 })