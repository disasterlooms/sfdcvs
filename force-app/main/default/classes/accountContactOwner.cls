public class accountContactOwner implements Queueable {   
    public Set<String> accntIds = null;  
    public accountContactOwner(Set<String> records) {  
        this.accntIds = records;  
    }   
    public void execute(QueueableContext qc) {        
        TriggerContextUtility.settriggerQueableFalse();
        List<Account> accs = [Select id, ownerid, owner_role__c, (Select id, ownerid from contacts limit 1000) 
                             from Account where id in : accntIds limit 100];
        
         Map<String,AccountUserTerritory2View> ownMap = new Map<String,AccountUserTerritory2View>();        
        for(AccountUserTerritory2View ot : [SELECT AccountId,Id,userid,RoleInTerritory2,Territory2Id 
                                            FROM AccountUserTerritory2View where AccountId in: accs and RoleInTerritory2 = 'Account Owner']){
                                                ownMap.put(ot.AccountId,ot);
                             }
        List <Contact> cons = new List<Contact>();
        for(Account a : accs){
            if(ownMap.containsKey(a.Id) && (!a.owner_role__c.contains('UVS')&& (!a.territoryOwner_Do_Not_Update__c))){
                AccountUserTerritory2View au = ownMap.get(a.Id);
                a.Ownerid = au.UserId;
                for(Contact c : a.Contacts){
                    c.OwnerId = au.UserId;
                    cons.add(c);
                }
            }
        }
        
        database.update(accs,false);
        database.update(cons,false);
        
        
    }  
  
}