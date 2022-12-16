trigger MasterTriggerProductAccessories on Accessories__c (
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                
               
            } 
            if (Trigger.isUpdate) {
                
            }
            if (Trigger.isDelete) {
                
            }
        }
        
        if (Trigger.IsAfter) {
            if (Trigger.isInsert) {
                 MasterAccessoriesClass.updateAcc(trigger.new);
                
            } 
            if (Trigger.isUpdate) {
                
            }
            if (Trigger.isDelete) {
                system.debug(Trigger.oldMap);
                MasterAccessoriesClass accs = 
                            new MasterAccessoriesClass(Trigger.oldMap, Trigger.newMap);
                        accs.updatedelAcc();
        }
        
    }
  }