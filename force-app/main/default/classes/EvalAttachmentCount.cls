public class EvalAttachmentCount {
    Map<Id, ContentDocumentLink> oldatt;
    Map<Id, ContentDocumentLink> newatt;
    
    
    public EvalAttachmentCount(
        Map<Id, ContentDocumentLink> oldTriggeratt,
        Map<Id, ContentDocumentLink> newTriggeratt) {
            oldatt = oldTriggeratt;
            newatt = newTriggeratt;
        }
    public static void evalAttach(List<ContentDocumentLink> attch){
        Set<Id> evalId = new Set<Id>();
        for(ContentDocumentLink c : attch){
            evalId.add(c.LinkedEntityId);
        }
        
        List<Eval_Request__c> evalcount = [Select id , Attachments__c  from Eval_Request__c where id in: evalId];
        
        if(evalcount.size() > 0){
            
            for(Eval_Request__c e :evalcount){
                if( e.Attachments__c == null ||  e.Attachments__c == 0){
                    e.Attachments__c = 1;
                }else{
                    e.Attachments__c = e.Attachments__c +1;
                }
            }
            update evalcount;
        }
        
        
    }
}