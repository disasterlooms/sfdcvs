({
	myAction : function(cmp, event, helper) {
		
	},
    
    sumbitDocument : function(cmp,event,helper){
        var congaTempId = event.getSource().get("v.name");
        console.log('conga temp id '+ congaTempId);
        cmp.set("v.congaTemplateId",congaTempId);        
        cmp.set("v.flownxtpg",true);
        console.log('change flow newxt');
    }
})