trigger MasterSpiffPricing on SpiffPricing__c(
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {        
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                
                //spiffpricing spiff = 
                    //new spiffpricing(Trigger.oldMap, Trigger.newMap);
                spiffpricing.updatename(trigger.new); 
                
            } 
            if (Trigger.isUpdate) {
                if(TriggerContextUtility.isFirstRun()){
                   TriggerContextUtility.setFirstRunFalse();
                   spiffpricing.updatename(trigger.new);  
                   
                    
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