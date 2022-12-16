trigger MasterQuoteTrigger on Quote
(before insert, after insert, 
 before update, after update, 
 before delete, after delete) {
     
     if (Trigger.isBefore) {
         if (Trigger.isInsert) {            
             QuoteUpdates.updatequote(trigger.New);
         } 
         if (Trigger.isUpdate) {            
             if(TriggerContextUtility.isFirstRun()){
                 QuoteUpdates qupdate = 
                     new QuoteUpdates(Trigger.oldMap, Trigger.newMap);
                 qupdate.upquote();
                 qupdate.inactivated();
             }
         }
         if (Trigger.isDelete) {
             // Call class logic here!
         }
     }
     
     if (Trigger.IsAfter) {
         
         if (Trigger.isInsert) { 
             TriggerContextUtility.setFirstRunFalse();
             QuoteUpdates.updatequotelines(trigger.New);
             QuoteUpdates.spateam(trigger.New);
             
         } 
         // changes for hotswap process 07292019 by Prasad	
         if (Trigger.isUpdate) {
             if(TriggerContextUtility.isFirstRun()){
                 TriggerContextUtility.setFirstRunFalse();
                 QuoteUpdates.updateHotSwapFlag(trigger.newMap,trigger.oldMap);
             }
         }
         if (Trigger.isDelete) {
             
             // Call class logic here!
         }
     }
     
 }