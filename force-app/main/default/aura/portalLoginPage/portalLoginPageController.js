({
	myAction : function(cmp, event, helper) {
        $A.get('e.force:refreshView').fire();
        /*
        let change = cmp.get("v.sideImageURL");
        //console.log('change class');
        //if(change){
           // var cmpTarget = cmp.find('imageStyle');
            //$A.util.addClass(cmpTarget, 'pp-col-leftSign');
        }
        */
	},

    onLoad : function(cmp,event,helper){
        //document.querySelector(".trigger").onclick();
        //console.log('get onclick event');
        
    }
})