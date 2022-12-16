trigger openOrderMasterTrigger on VSA_Open_Order__c(
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                TriggerContextUtility.setFirstRunFalse();
                
                
                 OpenOrderMasterClass checker = 
                        new OpenOrderMasterClass(Trigger.oldMap, Trigger.newMap);
                    checker.updateLookups(trigger.new);
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