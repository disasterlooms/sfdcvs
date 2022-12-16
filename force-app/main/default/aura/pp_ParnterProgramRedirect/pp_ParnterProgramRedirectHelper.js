({
    helperMethod : function() {
        
    }, 
    updateURL : function(cmp,event,helper){
        var langToSet = cmp.get("v.languageToSet");
        var langURL = '/?language='+langToSet;
        console.log('new url '+langURL);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": langURL
        });
        urlEvent.fire();
        window.location.reload();
    }
})