public class caseMasterClass{
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Case> oldCases;
    Map<Id, Case> newCases;
    
    List<Case> CasesToUpdate = new List<Case>();
    // This is the constructor
    // A map of the old and new records is expected as inputs
    public caseMasterClass(
        Map<Id, Case> oldTriggerCases, 
        Map<Id, Case> newTriggerCases) {
            oldCases = oldTriggerCases;
            newCases = newTriggerCases;
        }
    public void mapFields(List<Case> records) {
        
        Set<String> emails = new Set<String>();
        for(Case c : records){
            emails.add(c.Contact_Email__c);
        }
        
        Map<String,Contact> conEmails = new Map<String,Contact>();
        for(Contact con : [Select id, accountId, email from contact where email in : emails]){
            conEmails.put(con.email,con);
        }
        
        
        for(Case c : records){
            if(c.Origin == 'Education Portal'){
                if(conEmails.containsKey(c.Contact_Email__c)){
                    Contact con = conEmails.get(c.Contact_Email__c);
                    c.ContactId = con.Id;
                }
                c.AccountId = c.AccountIdText__c;
                system.debug('origin going in');
                system.debug(c.AccountId);
            }else{
                system.debug('orgin not going');
            }
        }
        
    }
}