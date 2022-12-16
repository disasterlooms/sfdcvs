trigger masterFinchSpiffSerials on finchLegacySerialNumbers__c(
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {        
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                //run context utility to prevent update triggers from running recursively
                if(TriggerContextUtility.isFirstRun()){   
                    masterFinchLegaySpiffSerials.assetUpdate(trigger.new);
                    masterFinchLegaySpiffSerials mfs = 
                        new masterFinchLegaySpiffSerials(trigger.oldMap,Trigger.NewMap);
                    
                }
                
                if (Trigger.isUpdate) {
                    if(TriggerContextUtility.isFirstRun()){   
                        
                    }
                }
                if (Trigger.isDelete) {
                    // Call class logic here!
                }
            }
        }
        
        if (Trigger.IsAfter) {
            if (Trigger.isInsert) {
                TriggerContextUtility.setFirstRunFalse();     
            } 
            if (Trigger.isUpdate) { 
                if(TriggerContextUtility.isFirstRun()){TriggerContextUtility.setFirstRunFalse();
                                                       
                                                       
                                                      }
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
    }