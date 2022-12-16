trigger MasterPOSAcctTrigger on POSAccountAliases__c (
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                //stop the update triggers from running on inserts that will cause updates
                TriggerContextUtility.setFirstRunFalse();
                PosAliasMasterClass.accAlias(trigger.New);
            } 
            if (Trigger.isUpdate) {     
                if(TriggerContextUtility.isFirstRun()){
                    TriggerContextUtility.setFirstRunFalse();  
                    PosAliasMasterClass.acctAliasMatch(trigger.New);
                    PosAliasMasterClass.accAlias(trigger.New);                  
                }            
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
        if (Trigger.IsAfter) {
            if (Trigger.isInsert) {                
             PosAliasMasterClass.acctAliasMatch(trigger.New);
                TriggerContextUtility.setFirstRunFalse();   
            } 
            if (Trigger.isUpdate) {
                system.debug('update trigger testing in debug');
                if(TriggerContextUtility.isFirstRun()){
                    TriggerContextUtility.setFirstRunFalse();
                }
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
    }