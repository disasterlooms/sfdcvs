trigger MasterEvalRequestTrigger on Eval_Request__c (
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                // Call class logic here!     
                EvalCreate.updateeval(trigger.new);
                
            } 
            if (Trigger.isUpdate) {
                masterEvalUpdate eval = 
                        new masterEvalUpdate(Trigger.oldMap, Trigger.newMap);
                    eval.closed();
                if(TriggerContextUtility.isFirstRun()){
                    //EvalRequestMaster.QuoteRequest(trigger.new);
                    TriggerContextUtility.setFirstRunFalse();
                    masterEvalUpdate.specialApproval(trigger.new); 
                    
                }
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
        
        if (Trigger.IsAfter) {
            if (Trigger.isInsert) {
                TriggerContextUtility.setFirstRunFalse();
                masterEvalUpdate.specialApproval(trigger.new); 
                
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