trigger MasterContentDocumentTrigger on ContentDocumentLink
(before insert, after insert, 
before update, after update, 
before delete, after delete) {
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            TriggerContextUtility.setFirstRunFalse();
            EvalAttachmentCount att = new 
                EvalAttachmentCount(
            Trigger.oldMap, Trigger.newMap);
            
            EvalAttachmentCount.evalAttach(trigger.new);
            
        } 
        
        if (Trigger.isDelete) {
            // Call class logic here!
        }
    }
    
    if (Trigger.IsAfter) {
        if (Trigger.isInsert) {
           TriggerContextUtility.setFirstRunFalse();
           
            
        } 
        
        if (Trigger.isDelete) {
            // Call class logic here!
        }
    }
}