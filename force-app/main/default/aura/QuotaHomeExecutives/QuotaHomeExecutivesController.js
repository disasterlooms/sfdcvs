({
	myAction : function(cmp, event, helper) {
        var userid = $A.get("$SObjectType.CurrentUser.Id");
        console.log('userid '+userid);
        if(userid == '005A0000000TGUjIAO' || userid == '005A0000000TGUj'){
            cmp.set("v.president", true);
            
        }else{
          cmp.set("v.president", false);  
        }
		
	}
})