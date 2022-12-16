public class PosAliasMasterClass {
    public static void acctAliasMatch(List<POSAccountAliases__c>records) {
        Map<String,POSAccountAliases__c> alias = new Map<String,POSAccountAliases__c>();       
        for(POSAccountAliases__c p : records){
            if(p.SFDC_Account__c != null){
                alias.put(p.Name , p);
                system.debug('acct '+p);
            }
        }       
        system.debug('map then records');
        system.debug(alias);
        system.debug(records);
        
        
        List<POSAccountAliases__c> names = [Select id,name,SFDC_Account__c from POSAccountAliases__c
                                            where name in: alias.keyset() and id not in: records];
        system.debug('names '+names);
        for(POSAccountAliases__c p : names){
            if(alias.containsKey(p.name)){
                POSAccountAliases__c acct = alias.get(p.name);
                p.SFDC_Account__c = acct.SFDC_Account__c;
                
            }            
        }
        
        update names;
        
    }
    public static void accAlias(List<POSAccountAliases__c>records) {
        Map<Id,Account> accts = new Map<Id,Account>();   
        for(POSAccountAliases__c p : records){
            if(p.SFDC_Account__c != null){
                Account a = new Account();
                a.Id = p.SFDC_Account__c;
                a.aliasChange__c = true;
                accts.put(a.Id,a);
            }            
        }
        update accts.values();
    }
    
}