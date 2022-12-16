trigger MasterQuoteLineItems on QuoteLineItem
(before insert, after insert, 
 before update, after update, 
 before delete, after delete) {
     
     if (Trigger.isBefore) {
         if (Trigger.isInsert) {
             TriggerContextUtility.setFirstRunFalse();
             
         } 
         if (Trigger.isUpdate) {            
             if(TriggerContextUtility.isFirstRun()){
                 TriggerContextUtility.setFirstRunFalse();
                 QuoteLineItemsMaster qlines = 
                     new QuoteLineItemsMaster(Trigger.oldMap, Trigger.newMap,trigger.new);
                 qlines.updateoppproducts();
                 qlines.pmapproved();
                 qlines.oppteam();
                 
             }
             
         }
         if (Trigger.isDelete) {
             // Call class logic here!
         }
     }
     
     if (Trigger.IsAfter) {
         if (Trigger.isInsert) {
             TriggerContextUtility.setFirstRunFalse();
             //QuoteLineItemsMaster.firsttime(trigger.new);
             QuoteLineItemsMaster.updateproducts(trigger.new);
             QuoteLineItemsMaster.spaApprovedCheck(trigger.new);
             
         } 
         if (Trigger.isUpdate) {
             
         }
         if (Trigger.isDelete) {
             // Call class logic here!
         }
     }
     
 }