({
	helperMethod : function() {
		
	},
    toggle: function (cmp, event,helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide"); 
    },
    
    createTablebody : function(cmp,event,helper){
        /*
        var users = cmp.get("v.myusers");
        var iters = 0;
        var i;
        
        
        for(i = 0; i < users.length; i ++){
            var newComponents = [];
            console.log('index of iter '+i);
            console.log('name of user '+cmp.get("v.myusers["+i+"].Name"));
            iters = iters +1;
            newComponents.push(["aura:html", {
            "tag": "tr"
       		 }]);
            
            newComponents.push(["aura:html", {
                "tag": "td"
            }]);
            
            newComponents.push([
                "lightning:input",
                        {
                            "type": "text",
                            "value": cmp.getReference("v.myusers["+i+"].Name"),
                            "readonly" : true
    
                        }]);
            newComponents.push(["aura:html", {
                "tag": "td"
            }]);
            
            newComponents.push([
                "lightning:input",
                        {
                            "type": "number",
                            "value": cmp.getReference("v.myusers["+i+"].Id"),
                            "onblur" : cmp.getReference("c.valuecheck")
    
                        }]);
            
            $A.createComponents(newComponents,
                function (components, status, errorMessage) {
                    
                    if (status === "SUCCESS") {
                        var pageBody = cmp.get("v.tablebody");
                        var tr = components[0];
                        pageBody.push(tr);
                        
                        var td = components[1];
                        var trBody = tr.get("v.body");
                        trBody.push(td);
                       
                        
                        var input = components[2];
                        var tdBody = td.get("v.body");
                        tdBody.push(input);
                        td.set("v.body", tdBody);
                        
                        var cells = cmp.get("v.labels"); 
                        
                        var td2 = components[3];
                        
                        var qinput = components[4];
                        
                        var x = 0;
                        for(x = 0; x < cells.length;x ++){
                            trBody.push(td2);
                                                        
                        }
                        //td2.set("v.body", td2Body);
                        
                        var s = 0;
                        for(s = 0; s < cells.length;s ++){
                            var qinput = components[4];
                            var td2Body = td2.get("v.body");
                            td2Body.push(qinput);
                                                        
                        }
                         td2.set("v.body", td2Body);
                        
                        tr.set("v.body", trBody);
                        
                        
                        cmp.set("v.tablebody", pageBody);
                    }
                    else // Report any error
                    {
                        this.displayToast("Error", "Failed to create list components.");
                    }
                }
            );
            
        }
        console.log(iters+' num of iterations');
        */
    },
    
    
})