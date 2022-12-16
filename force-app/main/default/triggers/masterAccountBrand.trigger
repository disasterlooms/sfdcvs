trigger masterAccountBrand on AccountBrand(
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                TriggerContextUtility.setFirstRunFalse();
            } 
            if (Trigger.isUpdate) {
                masterAccountBrandClass.updatedLogo(trigger.new);
                
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