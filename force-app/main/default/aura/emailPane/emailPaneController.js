({
    myAction : function(cmp, event, helper) {
        console.log('set account id');
        var emailfrom = cmp.get("v.people.from.email");
        var peopleEmails = [];
        peopleEmails.push("kasjfoiwjaefisjfiasjdfasdfj");
        var accts = cmp.get("c.getContacts");
        accts.setParams({
            "emails" : peopleEmails,
            "emailfrom" : emailfrom
        })
        console.log('check emails and peoples');
        console.log(peopleEmails);
        console.log(emailfrom);
        accts.setCallback(this,function(data){
            var rslt = data.getState();
       		if (rslt === "SUCCESS"){
                let acct = data.getReturnValue();
                console.log('freshdesk get acct data ');
                console.log(acct);
                try{
                    console.log(acct[0].Id);
                    cmp.set("v.recordId",acct[0].Id);
                    
                }catch(e){
                    cmp.set("v.recordId",acct.Id);
                }
            }else{
                console.log('there was errror in callbacl from get acct outlookemailpane class');                
            }
        });        
        $A.enqueueAction(accts);
        
        //cmp.set("v.recordId","0011200001FC7Gs");
    },
    itemsChange : function(cmp,event,helper){
        console.log('lwc started something');
        cmp.set("v.submission",false);
        //$A.get('e.force:refreshView').fire();
        

    }
})