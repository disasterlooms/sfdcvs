({
	myAction : function(component, event, helper) {
		
	},
    handleShowModal: function(component, evt, helper) {
        var modalBody;
        $A.createComponent("c:LikelyOppProducts", { recordId : component.get("v.recordId")},
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       header: "You have not selected any product(s) that are the most likely to be sold. Please select, update, and close",
                       body: modalBody, 
                       showCloseButton: true,
                       cssClass: "mymodal",
                       //closeCallback: function() {
                           //alert('You closed the alert!');
                       //}
                   })
               }                               
           });
    }
})