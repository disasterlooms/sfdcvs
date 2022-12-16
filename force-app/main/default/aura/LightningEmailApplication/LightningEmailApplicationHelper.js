({
	relatedOpps : function(cmp,event,helper) {
        var getopportunities = cmp.get("c.getOpps");
        var people = cmp.get("v.people");
        console.log('people object ');
        console.log(people);         
        var peopleEmails = helper.filterEmails(people);
        var emailfrom = cmp.get("v.people.from.email");
        
        getopportunities.setParams({
            "emails" : peopleEmails,
            "emailfrom" : emailfrom
        })
        
        getopportunities.setCallback(this,function(data){
            var rslt = data.getState();
       		if (rslt === "SUCCESS"){             
                cmp.set("v.opps",data.getReturnValue());
                
                console.log(data.getReturnValue());
            }else{
                
            }
        });        
        $A.enqueueAction(getopportunities);
        
        var getevals = cmp.get("c.getEvals");
        getevals.setParams({
            "emails" : peopleEmails,
            "emailfrom" : emailfrom
        })
        
        getevals.setCallback(this,function(data){
            var rslt = data.getState();
       		if (rslt === "SUCCESS"){             
                        cmp.set("v.evals",data.getReturnValue());
                console.log(data.getReturnValue());
            }else{
                
            }
        });        
        $A.enqueueAction(getevals);
        
        var cases = cmp.get("c.getCases");
        cases.setParams({
            "emails" : peopleEmails,
            "emailfrom" : emailfrom
        })
        
        cases.setCallback(this,function(data){
            var rslt = data.getState();
       		if (rslt === "SUCCESS"){             
                        cmp.set("v.cases",data.getReturnValue());
                console.log(data.getReturnValue());
            }else{
                
            }
        });        
        $A.enqueueAction(cases);
        
        var accts = cmp.get("c.getContacts");
        accts.setParams({
            "emails" : peopleEmails,
            "emailfrom" : emailfrom
        })
        
        accts.setCallback(this,function(data){
            var rslt = data.getState();
       		if (rslt === "SUCCESS"){             
                        cmp.set("v.accounts",data.getReturnValue());
                console.log(data.getReturnValue());
            }else{
                
            }
        });        
        $A.enqueueAction(accts);
        
        
        
        
		
	},
    filterEmails : function(people){
            return this.getEmailsFromList(people.to).concat(
                this.getEmailsFromList(people.cc));
    },

    getEmailsFromList : function(list){
            var ret = [];
            for (var i in list) {
            ret.push(list[i].email);
    }
     return ret;
  }
})