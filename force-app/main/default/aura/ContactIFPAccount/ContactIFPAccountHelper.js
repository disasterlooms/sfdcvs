({
	helperMethod : function() {
		
	}, 
    showSpinner : function(cmp,event,helper){
        var spinner = cmp.find("mySpinnerspa");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    hideSpinner : function(cmp,event,helper){
         var spinner = cmp.find("mySpinnerspa");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    createOppResellers : function (cmp,event,helper){
        $A.createComponent(
            "c:OpportunityPartners",
            {
                "recordId": cmp.get("v.Opp.Id"),
                "resellersOnly": true,
                "title" : "Resellers for Spa "+cmp.get("v.vsaorder.Spa_Number__c"),
                "disabled" : true
            },
            function(newButton, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    //var body = cmp.get("v.oppPartners");
                    //body.push(newButton);
                    cmp.set("v.oppPartners", newButton);
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
        
        $A.createComponent(
            "c:OpportunityContacts",
            {
                "recordId": cmp.get("v.Opp.Id"),
                "title" : "Contacts for Spa "+cmp.get("v.vsaorder.Spa_Number__c")
            },
            function(cons, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    //var body = cmp.get("v.oppPartners");
                    //body.push(newButton);
                    cmp.set("v.oppContacts", cons);
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
         helper.hideSpinner(cmp,event,helper);
    }
})