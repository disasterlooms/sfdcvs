trigger MasterUserTrigger on User (
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                getRegionInfo.getRegionUser(trigger.new);
            } 
            if (Trigger.isUpdate) {               
                if(TriggerContextUtility.isFirstRun()&& !system.isQueueable()){
                     getRegionInfo.getRegionUser(trigger.new);
                     UserMasterClass checker = 
                    new UserMasterClass(Trigger.oldMap, Trigger.newMap);
                  checker.portalUserUpdate();
                
                }
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
        
        if (Trigger.IsAfter) {
            if (Trigger.isInsert) {
                 TriggerContextUtility.setFirstRunFalse();
                UserMasterClass.newParnterUserCreated(trigger.new);
                if (!FutureContext.futureHasRun()) {
                    FutureContext.setFutureRan(); 
                    UserMasterClass.CreateContact(trigger.new);
                    
                }
            } 
            if (Trigger.isUpdate) {
                 if(TriggerContextUtility.isFirstRun()&& !system.isQueueable()){
                 TriggerContextUtility.setFirstRunFalse();
                 FutureContext.setFutureRan(); 
                 }
            }
        }
        if (Trigger.isDelete) {
             FutureContext.setFutureRan(); 
            // Call class logic here!
        }
    }