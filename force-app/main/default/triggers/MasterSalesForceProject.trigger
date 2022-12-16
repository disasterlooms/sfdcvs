trigger MasterSalesForceProject on SalesforceProject__c(
        before insert, after insert, 
        before update, after update, 
        before delete, after delete) {
            
            if (Trigger.isBefore) {
                if (Trigger.isInsert) {
                    TriggerContextUtility.setFirstRunFalse();
                   
                     
                } 
                if (Trigger.isUpdate) {
                    if(TriggerContextUtility.isFirstRun()){
                        TriggerContextUtility.setFirstRunFalse();
                        MasterSalesforceProject updatebefore = 
                            new MasterSalesforceProject(Trigger.oldMap, Trigger.newMap);
                        updatebefore.projpriority();
                        
                    }
                }
                if (Trigger.isDelete) {
                    
                }
            }
            
            if (Trigger.IsAfter) {
                if (Trigger.isInsert) {
                    TriggerContextUtility.setFirstRunFalse();
                    MasterSalesforceProject insertbefore = 
                        new MasterSalesforceProject(Trigger.oldMap, Trigger.newMap);
                    //latin america get state value and owner based on country
                    system.debug('trigger side new old ');
                    system.debug(Trigger.oldMap);
                    system.debug(Trigger.newMap);
                    insertbefore.projpriority();              
                     
                }                
            }
        }