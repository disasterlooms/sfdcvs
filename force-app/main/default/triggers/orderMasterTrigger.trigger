trigger orderMasterTrigger on Order(
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
         system.debug('trigger  running');
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                TriggerContextUtility.setFirstRunFalse();
                 ordersMasterClass checker = 
                        new ordersMasterClass(Trigger.oldMap, Trigger.newMap);
                    checker.pricebookSet(trigger.new);
            } 
            if (Trigger.isUpdate) {
                system.debug('trigger update running');
                system.debug('trigger context utility first run');
                system.debug(TriggerContextUtility.isFirstRun());
                
                if(TriggerContextUtility.isFirstRun()){
                    TriggerContextUtility.setFirstRunFalse();
                    
                       ordersMasterClass checker = 
                        new ordersMasterClass(Trigger.oldMap, Trigger.newMap);
                    //checker.portalUpdate(trigger.new);
                    
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
                ordersMasterClass checker = 
                        new ordersMasterClass(Trigger.oldMap, Trigger.newMap);
                    checker.spaUpdated();
                if(TriggerContextUtility.isFirstRun()){
                    TriggerContextUtility.setFirstRunFalse();    
                    
                    
                }
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
    }