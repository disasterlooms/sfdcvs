({
	myAction : function(cmp, event, helper) {
         var records = cmp.get("c.checkLocked");
        records.setParams({"recordId" : cmp.get("v.recordId")
                          });
        records.setCallback(this,function(resp){
            let state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                console.log('sucess checking record lock');
                console.log( resp.getReturnValue());                
                cmp.set("v.isLocked" , resp.getReturnValue());
                var navigate = cmp.get("v.navigateFlow");
                navigate("NEXT");
                
            }else{
                console.log('error gettin spa account info');
                var navigate = cmp.get("v.navigateFlow");
                navigate("NEXT");
                
            }            
        });
        $A.enqueueAction(records);   
		
	}
})