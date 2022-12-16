trigger masterContentDocumentLink on ContentDocumentLink(
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                TriggerContextUtility.setFirstRunFalse();
                
                masterContentDocumentLinkHelper.portalAccountDoc(trigger.new);
                
                //AccountStateOwners insertbefore = 
                  //  new AccountStateOwners(Trigger.oldMap, Trigger.newMap);
               
               
            } 
            if (Trigger.isUpdate) {
                if(TriggerContextUtility.isFirstRun()){
                    
                }
            }
            if (Trigger.isDelete) {
                
            }
        }
        
        if (Trigger.IsAfter) {
            if (Trigger.isInsert) {
                
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