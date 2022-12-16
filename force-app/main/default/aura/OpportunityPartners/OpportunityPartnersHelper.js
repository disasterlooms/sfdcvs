({	
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinnerpart");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})