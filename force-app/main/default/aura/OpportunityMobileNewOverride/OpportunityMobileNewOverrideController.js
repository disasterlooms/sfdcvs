({
    myAction : function(cmp, event, helper) {
        //get the user id, not as elegant as role but avoiding a server side controller. 
        //check if canda user, need to add new users and necessary. using both 18 and 15 digit ids to 
        //make sure it works. 
        //then pass the record type if it is canada. 
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var canada = ["005A0000000TGUhIAO", "0051H000007jfY4QAI", "005A0000000T6JHIA0","005A0000000TGUh", "0051H000007jfY4", "005A0000000T6JH"];
        var cteam = false;
        var i;
        for (i = 0; i < canada.length; i++) { 
            console.log(userId);
            console.log(canada[i]);
            if(canada[i] == userId){ 
                if(cteam == false){
                    cteam = true;
                }  
            }
        }
        var rectype = "012A0000000nzaYIAQ";        
        if(cteam == true){
            rectype = "0121H0000012dizQAA";
        }
        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Opportunity",
            "recordTypeId": rectype,
            "defaultFieldValues": {
                "Name" : "New Opp",
                "StageName": "Development"
            }
        });
        createRecordEvent.fire();
    },
    handleSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been created successfully.",
            "type": "success"
        });
        toastEvent.fire();
    }
})