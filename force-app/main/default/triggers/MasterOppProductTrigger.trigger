trigger MasterOppProductTrigger on OpportunityLineItem (
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        //the global trigger allows classes to turn of opportunity and account triggers
        //this allows to skip triggers and classes when batch or product classes are 
        
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                TriggerContextUtility.setFirstRunFalse();
                OppProductUpdates.newProduct(trigger.New);
                
                
            } 
            if (Trigger.isUpdate) {
                //OppProductUpdates checker = 
                //new OppProductUpdates(Trigger.oldMap, Trigger.newMap);
                // checker.productQuantity();
                if(TriggerContextUtility.isFirstRun()){ 
                }
                
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
        
        if (Trigger.IsAfter) {
            if (Trigger.isInsert) {
                TriggerContextUtility.setFirstRunFalse();
                system.debug('running schedule');
                OppProductUpdates.newSchedule(trigger.New);
                //stop the update triggers from running on inserts that will cause updates
                
                
            } 
            if (Trigger.isUpdate) {
                
                 if (TriggerContextUtility.isFirstRun()) {    
                  TriggerContextUtility.setFirstRunFalse();
                  OppProductUpdates.newSchedule(trigger.New);   
                 }
            }
            if (Trigger.isDelete) {
                TriggerContextUtility.setFirstRunFalse();
                // Call class logic here!
            }
            
        }
    }