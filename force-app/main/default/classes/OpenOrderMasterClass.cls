public class OpenOrderMasterClass{
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, VSA_Open_Order__c> oldOrders;
    Map<Id, VSA_Open_Order__c> newOrders;
    
    List<VSA_Open_Order__c> OrdersToUpdate = new List<VSA_Open_Order__c>();
    // This is the constructor
    // A map of the old and new records is expected as inputs
    public OpenOrderMasterClass(
        Map<Id, VSA_Open_Order__c> oldTriggerOrders, 
        Map<Id, VSA_Open_Order__c> newTriggerOrders) {
            oldOrders = oldTriggerOrders;
            newOrders = newTriggerOrders;
        }
    public void updateLookups(List<VSA_Open_Order__c> records) {
        Set<String> spas = new Set<String>();
        for(VSA_Open_Order__c o : records){
            spas.add(o.Spa_Number__c);
        }
        
        Map<String,Quote> lookups = new Map<String,Quote>();
        for(Quote q : [Select name,opportunityid,id,accountid from quote where name in : spas]){
            lookups.put(q.name ,q);
        }
        
        for(VSA_Open_Order__c ord : records){
            if(lookups.containsKey(ord.Spa_Number__c)){
                Quote q = lookups.get(ord.Spa_Number__c);
                ord.Account__c = q.AccountId;
                ord.Opportunity__c = q.OpportunityId;
                ord.Quote__c = q.Id;
                
            }
        }
        
        
    }
}