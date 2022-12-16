({
    myAction : function(cmp, event, helper) {
        var ind = cmp.get("v.industry");
        console.log(ind);
        console.log('industry myactiononloadmodal');
        if(ind.includes("Education")){
            //cmp.set("v.header","Education");
            //cmp.set("v.imgageUrl","https://www.viewsonic.com/skin/frontend/smartwave/viewsonic/images/solutions/education/interactive-learning-banner.jpg");
            
        }else if(ind.includes("Government")){
             //cmp.set("v.header","Government");
             //cmp.set("v.imgageUrl","https://www.viewsonic.com/media/contenttype/articles/Conference-Room.jpg");
             console.log('gove bander');
        }else{
             //cmp.set("v.header","Customer");
             //cmp.set("v.imgageUrl","https://www.viewsonic.com/media/contenttype/articles/Conference-Room.jpg");
        }
        
    },
    dismissModal : function(cmp,event,helper){
        cmp.set("v.hideModal","slds-hide");
        console.log('hide modal ');
        console.log(cmp.get("v.hideModal"));
    }
})