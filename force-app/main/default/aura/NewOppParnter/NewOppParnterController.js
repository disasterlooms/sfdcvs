({
	myAction : function(cmp, event, helper) {
		cmp.find("quote").set("v.value", cmp.get("v.recordId"));
	}
})