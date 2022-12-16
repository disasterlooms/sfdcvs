public without sharing class masterABMCompaniesClass{
   /*
    Map<Id, sixsense__X6sense_New_Company__c> oldComps;
    Map<Id, sixsense__X6sense_New_Company__c> newContacts;
     
    public masterABMCompaniesClass(
        Map<Id, sixsense__X6sense_New_Company__c> oldTriggerComps,
        Map<Id, sixsense__X6sense_New_Company__c> newTriggerComps) {
            oldComps = oldTriggerComps;
            newContacts = newTriggerComps;           
            
        }
     */
    public static void acctDomain() {
        /*
        List<String> web = new List<String>();
        
        for(sixsense__X6sense_New_Company__c a : records){
            web.add(a.sixsense__Website__c);
        }
        
        Map<String,Account> acct = New Map<String,Account>();
        for(Account a : [Select id , domain__c from account where domain__c in : web]){
            acct.put(a.domain__c , a);
        }
        
        
        for(sixsense__X6sense_New_Company__c a : records){
            if(acct.containsKey(a.sixsense__Website__c)){
                Account act = acct.get(a.sixsense__Website__c);
                a.sixsense__Account__c = act.Id;
            }
        }
        */
    }
}