({
	myAction : function(component, event, helper) {
		
	},
     handleSubmit: function(component, event, helper) {
            event.preventDefault();       // stop the form from submitting
            var fields = event.getParam('fields');
            fields.Street = '32 Prince Street';
            component.find('myRecordForm').submit(fields);
        },
    handleSuccess: function(component, event) {
        var updatedRecord = JSON.parse(JSON.stringify(event.getParams()));
        console.log('onsuccess: ', updatedRecord.id);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The Updated info has been saved",
            "type" : "success"
        });
        toastEvent.fire();
        $A.get('e.force:refreshView').fire();
    }
})