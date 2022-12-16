trigger MasterBundleProductsTrigger on Package__c (
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
            } 
            if (Trigger.isUpdate) {

                if(TriggerContextUtility.isFirstRun()){                    
                    //TriggerContextUtility.setFirstRunFalse();
                }
            }
            if (Trigger.isDelete) {
              MasterBundleProduct pack = 
                        new MasterBundleProduct(Trigger.oldMap, Trigger.newMap);
                pack.updateParentdel();
            }
        }
        
        if (Trigger.IsAfter) {
            
            if (Trigger.isInsert) {
                 if(TriggerContextUtility.isFirstRun()){
                TriggerContextUtility.setFirstRunFalse();
                MasterBundleProduct.updateParent(Trigger.new);
                 }
                
                
            } 
            if (Trigger.isUpdate) {
                
                if(TriggerContextUtility.isFirstRun()){
                    TriggerContextUtility.setFirstRunFalse();
                    MasterBundleProduct.updateParent(Trigger.new);
                }
            }
            if (Trigger.isDelete) {
                // Call class logic here!
                
            }
        }
    }