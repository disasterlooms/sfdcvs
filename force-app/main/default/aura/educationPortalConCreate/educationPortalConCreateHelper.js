({
    helperMethod : function() {
        
    },
    saveAccount : function(cmp,event,helper){
        console.log('submit Account');
        //var eventFields = event.getParam("fields");
        var accfelds = cmp.find('myAccount');
        console.log(accfelds.eventFields);
        console.log(accfelds);
        //.submit(eventFields);
        
    },   
    sameasLRP : function(cmp,event,helper){
        //cmp.set("v.contacts[1].FirstName",cmp.get("v.contacts[0].FirstName"));
        //cmp.set("v.contacts[1].LastName",cmp.get("v.contacts[0].LastName"));
        //cmp.set("v.contacts[1].Phone",cmp.get("v.contacts[0].Phone"));
    },
    
    validation : function(cmp,event,helper){
        var step = cmp.get("v.step"); 
        
        var contact1 = cmp.get("v.contacts[0]");
        var contact2 = cmp.get("v.contacts[1]");
        
        console.log('con1');
        if(step == 1){
            if(contact1.FirstName == '' ||
               contact1.LastName == '' ||
               contact1.Email == '' ||
               contact1.Phone == ''){
                console.log('error');
                helper.removespinner(cmp,event,helper);
                alert('Please fill all fields');
            }else{
                console.log('good ');
                helper.removespinner(cmp,event,helper);
                helper.advanceStep(cmp,event,helper);
            }  
        }else if(step ==2 ){
            if(contact2.FirstName == '' ||
               contact2.LastName == '' ||
               contact2.Email == '' ||
               contact2.Phone == ''){
                console.log('error');
                helper.removespinner(cmp,event,helper);
                alert('Please fill all fields or if the same, Click Skip and Finish');
            }else{
                console.log('good ');
                helper.removespinner(cmp,event,helper);
                helper.advanceStep(cmp,event,helper);
            }  
            
        }
        
        
    },
    advanceStep : function(cmp,event,helper){
        var step = cmp.get("v.step"); 
        var contacts = cmp.get("v.contacts");
        
        if(contacts[step]){
            console.log('not null');            
        }else{
            console.log('null');  
            var contacts = [];        
            contacts.push({
                "AccountId" : null,
                "FirstName" : null,
                "LastName" : null,
                "Email" : null ,
                "Phone" : null,
                "ViewBoard_User_Type__c" : null,
                "ViewSchool__c" : null,
                "Marketing_Post_Sales__c" : null,
            });
            cmp.set("v.contacts",contacts);
        }
        helper.removespinner(cmp,event,helper);        
        
        
        var step = cmp.get("v.step");
        var progress = cmp.get("v.progress");
        
        
        
        console.log('con created succesfully reseting');
        cmp.set("v.step",step+1);
        cmp.set("v.progress",progress+25);
        var reset = '';
        cmp.set("v.firstname",reset);
        cmp.set("v.lastname",reset);
        cmp.set("v.phone",reset);
        cmp.set("v.email",reset);
        
    },
    addspinner: function (cmp, event,helper) {
        $A.createComponent(
            "lightning:spinner",
            {
                "variant ": "brand",
                "size": "large"
            },
            function(newButton, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(newButton);
                    cmp.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                        // Show error message
                    }
            }
        );
    },
    removespinner : function (cmp, event,helper) {
        cmp.set("v.body",'');
        
    },
    saveContacts : function(cmp,event,helper){
        var action = cmp.get("c.createCon");
        action.setParams({
            "acctId" : cmp.get("v.acct"),
            "firstname" : cmp.get("v.firstname"),
            "lastname" : cmp.get("v.lastname"),
            "email" : cmp.get("v.email"),
            "phone" : cmp.get("v.phone"),
            "utype" : cmp.get("v.utype"),
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the products to be displayed
                helper.advanceStep(cmp,event,helper);
            }
            else{
                // alert(resp.getError());
                helper.removespinner(cmp,event,helper);
                console.log('erroradding account');
                console.log(resp.getError());
            }
        });
        $A.enqueueAction(action);
    },
    toast : function(cmp, event, helper) {
        console.log('toast');
        var severity = 'success'; //it could be 'confirm' or null
        var title = 'User(s) Added';
        var message = 'You can now manage your account';
        var messageContainer = cmp.find("messageContainer");
        messageContainer.displayMessage(severity,title,message);
    },
     toastError : function(cmp, event, helper) {
        var err = cmp.get("v.erromsg");
        console.log('toasterror');
        var severity = 'error'; //it could be 'confirm' or null
        var title = 'There was an error ';
         if(err.includes('Duplicate')){
             err = 'You may have added the same user twice, please only enter a user 1 time. You can Skip and finish if Super User is Same as IT Management '+err;
         }
        var message = err;
        var messageContainer = cmp.find("messageContainer");
        messageContainer.displayMessage(severity,title,message);
    }
})