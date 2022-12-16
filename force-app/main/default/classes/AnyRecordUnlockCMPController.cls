public class AnyRecordUnlockCMPController {    
    
    @AuraEnabled 
    public static void getUnclockRecord(string currentRecord){
        String objectAPIName = '';
        if(currentRecord != null){         
            
           string keyPrefix = currentRecord.substring(0,3);
            for( Schema.SObjectType obj : Schema.getGlobalDescribe().Values() ){
                String prefix = obj.getDescribe().getKeyPrefix();
                if(prefix == keyPrefix){
                    objectAPIName = obj.getDescribe().getName();
                    break;
                }
            }
        }
        
         Approval.unlock(currentRecord);
        
        string query = 'select id,record_is_locked__c from '+objectAPIName+' where Id =\''+currentRecord+'\'';    
        sObject record= Database.query(query);
        record.put('record_is_locked__c', false);
        update record;
        
        
    }
}