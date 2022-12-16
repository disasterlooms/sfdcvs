trigger masterAssetTrigger on Asset (
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                if(TriggerContextUtility.isFirstRun()){
                    MasterAssetClass.assetNullData(trigger.New);
                    if(trigger.New[0].TP__c != null){
                        MasterAssetClass.newAsset(trigger.New);
                    }                    
                } 
            }
            if (Trigger.isUpdate) {
                if(TriggerContextUtility.isFirstRun()){   
                    
                    MasterAssetClass mac = new MasterAssetClass(Trigger.oldMap, Trigger.newMap);
                    
                    if(trigger.New[0].TP__c != null){    
                        MasterAssetClass.newAsset(trigger.New);
                    }
                    mac.spiffRequestClaimed();
                    
                    if(TriggerContextUtility.isFirstRun()){
                        TriggerContextUtility.setFirstRunFalse();
                        // MasterAssetClass.newAsset(trigger.New);
                    }
                }
                
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
        
        if (Trigger.IsAfter) {            
            TriggerContextUtility.setFirstRunFalse();
            if (Trigger.isInsert) {
                
            } 
            if (Trigger.isUpdate) {
                
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
    }