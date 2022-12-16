({
	myAction : function(component, event, helper) {
		
	},
    gotoURL : function (component, event, helper) {
    var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "/analytics/wave/wave.apexp?tsid=02u12000000jWdG#application/00l1H000001Uy7LQAS/view/dashboard/0FK1H000000GoMiWAK"
    });
    //urlEvent.fire();
    //window.open('/analytics/wave/wave.apexp?tsid=02u12000000jWdG#application/00l1H000001Uy7LQAS/view/dashboard/0FK1H000000GoMiWAK','_top');

}
})