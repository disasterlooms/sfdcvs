trigger MasterProductTrigger on Product2 (
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {        
        if(!test.isRunningTest()){
            TriggerContextUtility.setGlobalTriggersFalse();
        }       
        //turning off opporutnity and account triggers when doing product updates. 
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                
                ProductChanges.newproduct(Trigger.new);
                
                
            } 
            if (Trigger.isUpdate) {
                
                ProductChanges checker = 
                    new ProductChanges(Trigger.oldMap, Trigger.newMap);
                checker.LandingCostChange();
                
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