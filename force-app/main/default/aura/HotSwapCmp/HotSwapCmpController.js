({
    Submit:function(cmp, event, helper) {
        
         var checkboxes = cmp.find("DependentCheckboxpart");
        var records = cmp.get("v.spaProductRecords");
        var productList=[];
        for (var k = 0; k < checkboxes.length; k++){
            //debugger;
            if(checkboxes[k].get("v.checked") == true ){                    
                for(var j=0; j<records.length; j++){
                    
                    if( checkboxes[k].get("v.name") == records[j].Id){
                        productList.push(records[j]);
                        continue;
                    }
                }
            }
        }
           
        helper.getUpdateSpaProducts(cmp,productList);
    },
	nextPage: function(cmp, event, helper) {
         var nextpage = cmp.find('nextPage');
        $A.util.toggleClass(nextpage, 'slds-hide');
        
        var firstPage = cmp.find('firstPage');
        $A.util.toggleClass(firstPage, 'slds-hide');
        
		helper.getSpaProducts(cmp);
	},
    prevPage: function(cmp, event, helper) {
         var nextpage = cmp.find('nextPage');
        $A.util.toggleClass(nextpage, 'slds-hide');
        
        var firstPage = cmp.find('firstPage');
        $A.util.toggleClass(firstPage, 'slds-hide');
        
    },
    close: function(cmp, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	},   
    
     hideSpinner : function (component, event, helper) {
        component.set("v.Spinner", false);
    },
    //spinner show
    showSpinner : function (component, event, helper) {
        component.set("v.Spinner", true); 
    },
    doDisable:function(cmp, event, helper){
        debugger;
       var qtySold = event.getSource().get("v.value"); 
        if(! $A.util.isEmpty(qtySold)){
             cmp.set("v.ifMandatoryQty", false);
        }
        
    },
    showalert:function(cmp, event, helper){
         var hotSwapqtySold = event.getSource().get("v.value"); 
        if(! $A.util.isEmpty(hotSwapqtySold)){
            cmp.set("v.ifMandatoryQty", true);
        }
     var toastEvent = $A.get("e.force:showToast");               
                toastEvent.setParams({
                   title : 'Warning',
                    message: 'Please fill Sold Quantity for selected products to submit HotSwap request',
                    duration:'5',
                    key: 'info_alt',
                    type: 'warning',
                    mode: 'sticky'
                });
                toastEvent.fire();
               // $A.get("e.force:closeQuickAction").fire();
},
    showWarning:function(cmp, event, helper){
        cmp.set("v.ifMandatoryQty", true);
       var checkbox = event.getSource().get("v.checked"); 
      
        if(checkbox){
                    var toastEvent = $A.get("e.force:showToast");               
                toastEvent.setParams({
                     title : 'Warning',
                    message: 'Please fill Hot Swap Quantity & Sold Quantity for selected products to submit HotSwap request',
                    duration:' 5',
                    key: 'info_alt',
                    type: 'warning',
                    mode: 'sticky'
                
                });
                toastEvent.fire();
         	// $A.get("e.force:closeQuickAction").fire();
        }
       
    }
})