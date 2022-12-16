public with sharing class OpportunityUnlock {
    @AuraEnabled
    public static void unlockrec(String oppid){
        system.debug(oppid);
        Approval.unlock(oppid);
        
        opportunity opp = [Select id, record_is_locked__c from opportunity where id =: oppid limit 1];
        opp.record_is_locked__c = false;
        update opp;
    }
}