trigger caseMasterTrigger on Case(
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                TriggerContextUtility.setFirstRunFalse();
                 caseMasterClass checker = 
                        new caseMasterClass(Trigger.oldMap, Trigger.newMap);
                    checker.mapFields(trigger.new);
            } 
            if (Trigger.isUpdate) {
                if(TriggerContextUtility.isFirstRun()){
                    TriggerContextUtility.setFirstRunFalse(); 
                    
                }
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
        
        if (Trigger.IsAfter) {
            if (Trigger.isInsert) {
                TriggerContextUtility.setFirstRunFalse();
                
            } 
            if (Trigger.isUpdate) {
                if(TriggerContextUtility.isFirstRun()){
                    TriggerContextUtility.setFirstRunFalse();    
                    
                    
                }
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
    }