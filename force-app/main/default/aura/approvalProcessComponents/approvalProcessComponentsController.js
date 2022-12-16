({
    myAction : function(cmp, event, helper) {
        console.log('action running');
        //console.log(cmp.get("c.getRecId"));
        var action = cmp.get("c.getRecId");
        var recid = cmp.get("v.recordId");
        
        action.setParams({
            "recordId": recid
        });
        console.log('approval rec id '+ recid);
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                console.log('get related rec id '+ resp.getReturnValue());
                var relrecord = resp.getReturnValue();
                cmp.set("v.relatedRecId",relrecord);
                
                if(cmp.get("v.getParentID") == false){
                    helper.createCMP(cmp,event,helper);   
                }else{
                   helper.getParentRecId(cmp,event,helper);  
                }
                if(relrecord){
                    cmp.set("v.objType",relrecord.substring(0,3));
                }
                
                
            }
            else{
                alert(resp.getError());
            }
        });
        $A.enqueueAction(action);
    },
    
    parentRecord : function(cmp,event,helper){
        console.log('parent record running');
        if(cmp.get("v.getParentID") == true){
            var pfield = cmp.get("v.parentfieldname");
            cmp.set("v.parentId", cmp.get("v.pRecord."+pfield));
            console.log('parent id ');
            console.log(cmp.get("v.parentId"));
            helper.createCMP(cmp,event,helper);
        }
    },
    recordLoadError : function(cmp,event,helper){
    }
})