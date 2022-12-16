public class AccountVIP {
    @AuraEnabled
    public static Account getRecord(String recid){
        Date d = date.today();
        system.debug('recid');
        
        Account a = [Select id,VIP_Request_Type__c,VIP_Service_Expiration_Date__c, (select Product2.Name from assets where product2Id != null
                                                                                    and TP__c = null and SerialNumber = null)
                     from Account where id in (Select AccountId from Quote where id = : recid)];
        //and VIP_Request_Type__c = 'VIP Express Exchange' and VIP_Service_Expiration_Date__c > :d
        system.debug('account');
        system.debug(a);
        
        return a;
        
        
    }
    
}