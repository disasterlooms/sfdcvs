({
	toggleClass: function(cmp,componentId,className) {
		var modal = cmp.find(componentId);
		$A.util.removeClass(modal,className+'hide');
		$A.util.addClass(modal,className+'open');
	},

	toggleClassInverse: function(cmp,componentId,className) {
		var modal = cmp.find(componentId); 
		$A.util.addClass(modal,className+'hide');  
		$A.util.removeClass(modal,className+'open');
	},
    update : function(cmp,event,helper){
        var upsettings = cmp.get("c.updateSettings");
        upsettings.setParams({"settings": cmp.get("v.settings"),
                            });
        upsettings.setCallback(this, function(data){
            var rslt = data.getState();
       		if (rslt === "SUCCESS"){
                helper.toggleClassInverse(cmp,'backdrop','slds-backdrop--');
                helper.toggleClassInverse(cmp,'modaldialog','slds-fade-in-');
            }else{
                helper.toggleClassInverse(cmp,'backdrop','slds-backdrop--');
                helper.toggleClassInverse(cmp,'modaldialog','slds-fade-in-');
                console.log('There were some errors on the save');
            }
            
        });
        $A.enqueueAction(upsettings);
    }
})