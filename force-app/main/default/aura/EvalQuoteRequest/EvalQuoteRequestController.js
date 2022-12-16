({
	myAction : function(cmp, event, helper) {
		//helper.spinner(cmp, event, helper);
	},
    billCon : function(cmp,event,helper){
        console.log('button clicked');
        var recid = cmp.get("v.contactSelected");
        console.log(recid);
       cmp.set("v.contactSelected", cmp.get("v.billingContact"));
    },
    shipCon : function(cmp,event,helper){
        cmp.set("v.contactSelected", cmp.get("v.shippingContact"));
        
    }, 
    resellerCon : function(cmp,event,helper){
        cmp.set("v.contactSelected", cmp.get("v.resellerContact"));
        
    }, 
    handleCreateLoad : function(cmp,event,helper){
        console.log('load handler')
        helper.spinnerRemove(cmp, event, helper);
    },
    handleSubmit: function(cmp, event, helper) 
   {
       console.log('submit running');
       event.preventDefault();
       
       var values = event.getParam("fields");
       cmp.set("v.contactname", values["FirstName"]+" "+values["LastName"]);
       cmp.set("v.street", values["MailingStreet"]);
       cmp.set("v.city", values["MailingCity"]);
       cmp.set("v.state", values["MailingState"]);
       cmp.set("v.postal", values["MailingPostalCode"]);
       cmp.set("v.country", values["MailingCountry"]);
       cmp.set("v.email", values["Email"]);
       cmp.set("v.phone", values["Phone"]);
       console.log('acct id');
       console.log(values["AccountId"])
       cmp.set("v.acctId", values["AccountId"]);
       
       var navigate = cmp.get('v.navigateFlow');
       navigate("NEXT");
   }
    
})