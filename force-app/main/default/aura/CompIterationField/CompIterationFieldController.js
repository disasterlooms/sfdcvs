({
    myAction : function(component, event, helper) {
        var fieldname = component.get("v.fieldName");
        $A.createComponent(
            "ui:outputText",
            {
                "value": component.get("v.obj."+fieldname),
                "click" : component.getReference("c.selected"),
                "title" :  component.get("v.obj."+'Id')

            },
            function(msgBox){                
                if (component.isValid()) {
                    var targetCmp = component.find('outtext');
                    var body = targetCmp.get("v.body");
                    body.push(msgBox);
                    targetCmp.set("v.body", body); 
                }
            }
        );
        
        //component.set( field , field.replace("<br>", " - "));
    },
    selected : function(cmp,event,helper){
        console.log('selected');
        var id = event.getSource().get("v.title")
        console.log(id);
        //cmp.set("v.wherestmt", 'where Product_Package__c = '+id);
        var parentId = $A.get("e.c:rowSelectedId");
        parentId.setParams({ "parentid":  id});
        parentId.fire(); 
    }
})