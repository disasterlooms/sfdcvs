trigger contentVersionMasterTrigger on ContentVersion(
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                TriggerContextUtility.setFirstRunFalse();
            } 
            if (Trigger.isUpdate) {   
                system.debug('content version is running');
                masterContentVersionClass.moveWNine(trigger.new);
                if(TriggerContextUtility.isFirstRun()){
                    
                    
                    TriggerContextUtility.setFirstRunFalse();
                }
                TriggerContextUtility.setFirstRunFalse();
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
        
        if (Trigger.IsAfter) {
            if (Trigger.isInsert) {
                
                
                
                
            } 
            if (Trigger.isUpdate) {
                
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
    }