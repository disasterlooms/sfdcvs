({
	helperMethod : function() {
		
	},
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide"); 
    },
    hide: function(cmp,componentId,className) {
		
        cmp.set("v.open", false);
        cmp.set("v.open2", false);
        cmp.set("v.open3", false);
        cmp.set("v.open4", false);

	},

	show: function(cmp,componentId,className) {
		var btn = cmp.get("v.button");
        //var mod = cmp.get("v.open");
        //console.log(mod);
        console.log(btn);
        if(btn == "comoppteam"){
          cmp.set("v.open", true);  
        }else if(btn == "accts"){
          cmp.set("v.open2", true);  
        }else if(btn == "opps"){
           cmp.set("v.open3", true); 
        }else if(btn == "oppteams"){
           cmp.set("v.open4", true); 
        }
        
        
	},
})