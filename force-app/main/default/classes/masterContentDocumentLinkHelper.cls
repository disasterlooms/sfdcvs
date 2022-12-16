public class masterContentDocumentLinkHelper{
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, ContentDocumentLink> oldLink;
    Map<Id, ContentDocumentLink> newLink;
    
    public masterContentDocumentLinkHelper(
        Map<Id, ContentDocumentLink> oldTriggerLink, 
        Map<Id, ContentDocumentLink> newTriggerLink) {
            oldLink = oldTriggerLink;
            newLink = newTriggerLink;
        }
    public static void portalAccountDoc(List<ContentDocumentLink> records) {
        Map<String,Account> acc = new Map<String,Account>();
        
        Set<Id> linkedIds = new Set<Id>();
        
        for(ContentDocumentLink c : records){
            linkedIds.add(c.LinkedEntityId);
        }
        
        for(Account a : [Select id, isPartner from Account where Id in : linkedIds]){
            acc.put(a.Id, a);
        }
        
       for(ContentDocumentLink c : records){
           if(acc.containsKey(c.LinkedEntityId)){
               Account a = acc.get(c.LinkedEntityId);
               if(a.IsPartner){
                   c.ShareType = 'I';
                   c.Visibility = 'AllUsers';
               }
           }
        }
        
        
    }
    
}