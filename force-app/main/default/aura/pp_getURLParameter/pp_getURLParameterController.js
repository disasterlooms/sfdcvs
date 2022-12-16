({
	onPageReferenceChange : function(cmp, event, helper) {
		console.log('get page reference');
        var myPageRef = window.location.href;
        console.log(myPageRef);
        var userId = myPageRef.split('rid=')[1];
        console.log('ref id '+userId);
        cmp.set("v.refId",userId);
        
	}
})