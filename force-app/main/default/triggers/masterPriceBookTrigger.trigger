trigger masterPriceBookTrigger on Pricebook2 (
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                masterPriceBookHelperClass.newproduct(trigger.new);
                masterPriceBookHelperClass mp = new masterPriceBookHelperClass(Trigger.oldMap, Trigger.newMap);
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