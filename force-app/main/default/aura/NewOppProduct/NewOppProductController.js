({
	showOppmodal: function(component, event, helper) {
		 //Toggle CSS styles for opening Modal
		helper.toggleClass(component,'backdrop','slds-backdrop--');
        console.log('show new prod modal');
		helper.toggleClass(component,'modaldialog','slds-fade-in-');
        helper.getoppid(component,event);
	},
	hideModal : function(component, event, helper) {
		 //Toggle CSS styles for hiding Modal
        helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'modaldialog','slds-fade-in-');
        var clear = $A.get("e.c:ClearProductSeletedNewProd");
        clear.fire(); 
	},
   createprod: function (cmp, event,helper) {
       var quant = cmp.get("v.newquan");
       var ship = cmp.get("v.newship");
       console.log('status '+cmp.get("v.newstatus"));
       if(isNaN(quant) || ship == null || cmp.get("v.selectedId") == null || cmp.get("v.newstatus") ==  '' ){
         alert('All Required fields must be Inputed! You must click on the Product SKU, not just type it. Status cannot be none.');
       }else{
           var spinner = document.getElementById("spinnerdiv");
           $A.util.removeClass(spinner, 'hideme');
           console.log('date');
           var shipdate = cmp.get("v.newship");
           console.log(shipdate);
           console.log(cmp.get("v.newoppid"));
           var newopp = cmp.get("v.newoppid");
           var action = cmp.get("c.newprod");
           action.setParams({"oppid" : newopp,
                              "prodid": cmp.get("v.selectedId"),
                              "quant": cmp.get("v.newquan"),
                              "ship": shipdate,
                              "status": cmp.get("v.newstatus"),
                              "compete": cmp.get("v.newcompete")});
            action.setCallback(this, function(data) {
                var rslt = data.getState();
                if (rslt === "SUCCESS"){
                    var cmpTarget = cmp.find('Modalbox');
                    var cmpBack = cmp.find('MB-Back');
                    $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
                    $A.util.removeClass(cmpBack, 'slds-backdrop--open');
                    $A.util.addClass(spinner, 'hideme');
                    //clear out the values for the product
                    cmp.set("v.objNew.Id", null);
                    cmp.set("v.newquan", null);
                    cmp.set("v.newstatus", null);
                    cmp.set("v.newcompete", null);
                    cmp.set("v.newship", null);
                    //refresh the opportunity search                
                    var refresh = $A.get("e.c:oppsearch");
                    refresh.fire();
                    //close the modal
                    helper.toggleClassInverse(cmp,'backdrop','slds-backdrop--');
					helper.toggleClassInverse(cmp,'modaldialog','slds-fade-in-');
                    
                }else{
                    $A.util.addClass(spinner, 'hideme');        
                    var errors = data.getError();
                    alert('There were some errors on the insert. '+errors[0].message);
                }
            });
            $A.enqueueAction(action);           
       }
   }
})