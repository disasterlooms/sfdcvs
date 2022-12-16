({
	myAction : function(component, event, helper) {
		
	},
    submision : function(cmp,event,helper){
        
    },
    onButtonPressed: function(cmp, event, helper) {
      var navigate = cmp.get('v.navigateFlow');
      navigate("NEXT");
   }
})