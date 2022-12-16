public class MasterEventClass{
    Map<Id,Event> oldEvents;
    Map<Id,Event> newEvents;
    public MasterEventClass(Map<Id,Event> oEvents,Map<Id,Event> nEvents){
        oldEvents = oEvents;
        newEvents = nEvents;        
    }
    public static void privateevent(List<Event> records){
        List<Event> EventsToDelete = [Select id from Event where isPrivate = true and id in: records];
        database.delete(EventsToDelete, false);
        
    }
    public static void typeSearch(List<Event> records){
        // Get subject and map keywords to get type using the metadata type to cross reference
        // because the types may change and the keywords may change 
        // the map could be a list but used a map in case we want to use it later
        
        Map<String,Event_Types__mdt> etypes = new Map<String,Event_Types__mdt>();
        for(Event_Types__mdt et: [Select Id, Event_Types__c , Subject_Matching_Phrase__c ,Type_Rank__c 
                                  from Event_Types__mdt])
            etypes.put(et.Subject_Matching_Phrase__c.toLowerCase() , et);
        system.debug('running event trigger'); 
        system.debug(etypes);
        system.debug(records);
        for(Event e : records){
            if(e.subject != null){
                for(Event_Types__mdt types : etypes.values()){
                    String sub = e.Subject.toLowerCase();
                    system.debug(sub);
                    system.debug(types.Subject_Matching_Phrase__c);
                    system.debug(types.Subject_Matching_Phrase__c.toLowerCase());
                    
                    if(sub.contains(types.Subject_Matching_Phrase__c.toLowerCase()) && String.isBlank(e.type)) {
                        e.type = types.Event_Types__c; 
                    } 
                    
                }
                
            }
            
            
        } 
        
    }
    
}