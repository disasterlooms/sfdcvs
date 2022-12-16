trigger masterSpiffRequestTrigger on Spiff_Request__c(
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                //run context utility to prevent update triggers from running recursively
                TriggerContextUtility.setFirstRunFalse();
                masterSpiffRequestHelperClass.newSpiff(trigger.new);
                masterSpiffRequestHelperClass.endUserMap(trigger.new);
                    } 
            if (Trigger.isUpdate) {
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
                masterSpiffRequestHelperClass.getSpiffPromotional(trigger.new);
                
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