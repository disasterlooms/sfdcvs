({
    hideModal : function(cmp,event,helper) {
		var cmpTarget = cmp.find('modaldialog');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpTarget, 'slds-fade-in-hide');
        console.log('hide');
	},

	showModal : function(cmp,event,helper) { 
		var cmpTarget = cmp.find('modaldialog');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-hide');
        console.log('show');
	},
    dismissForever : function(cmp,event,helper) {
        localStorage.setItem('modalOpenOrder','false');
	},
    dismissToday : function(cmp,event,helper) {
        var ts = Math.round(new Date().getTime() / 1000);
		var tomorrow = ts + (24 * 3600);
        localStorage.setItem('modalOpenOrderTime',tomorrow);
	},
})