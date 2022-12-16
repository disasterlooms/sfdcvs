({
    myAction : function(cmp, event, helper) {
        var counter = cmp.get("v.scriptCounter");
        if(counter > 0){
            return;
        }else{
            cmp.set("v.scriptCounter", 1);
        }
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        console.log('base url is '+baseURL);
        console.log('contains buiulder '+urlString.includes("preview"));
        cmp.set("v.cbaseURL", baseURL);
        if(urlString.includes("preview")){
            console.log('this is builder');
            return;
        }
		var ppCheck = false;
        if(baseURL == 'https://partner.viewsonic.com'
        || 'https://fullsand-viewsonic.cs223.force.com'){
           ppCheck = true;
            console.log('Parnter site');
            
           }
        
        console.log('language iso code comment next with page param');
        console.log(cmp.get("v.pageReference"));
        var langUsed = cmp.get("v.language");
        var langToSet = cmp.get("v.languageToSet");
        console.log('language iso from url '+langUsed);
        console.log('language iso to be used '+langToSet);
        if(langUsed != langToSet && ppCheck == true){
            console.log('lets change the language url');
            helper.updateURL(cmp,event,helper);  
            
        }else{
            console.log('all is good in the language good sir');
        }
        
    }
})