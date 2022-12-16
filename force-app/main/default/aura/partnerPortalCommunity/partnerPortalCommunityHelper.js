({
    helperMethod : function() {
        
    },
    requestCode : function(cmp,helper,event){
        var action = cmp.get("c.getCode");
        var dmn = cmp.get("v.domain");

        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                var theCode = resp.getReturnValue();    
                cmp.set("v.code",theCode);
                //console.log('ret value '+ theCode);
                var userId = $A.get("$SObjectType.CurrentUser.Id");
                console.log('domain and user id no code '+dmn+' '+userId);
                if(userId == '005A0000000T6JG' || dmn == 'gmailmagical.com'){
                    console.log('ret value '+ theCode);
                }
                
                var navigate = cmp.get('v.navigateFlow');
                navigate('NEXT');
            }
            else{
                // alert(resp.getError());
                console.log('error gettin domain info');
                console.log(resp.getError());
            }
        });
        $A.enqueueAction(action);
        
    }
})