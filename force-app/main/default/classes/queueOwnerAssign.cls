public class queueOwnerAssign implements Queueable {
    private Set<String> accounts;
    public queueOwnerAssign(Set<String> records) {
        this.accounts = records;
    }
    public void execute(QueueableContext context) {
        system.debug('accts in 2nd queable'+accounts);
        List<Account>accToUpdate = [Select id,OwnerId from Account where id in : accounts];
        Map<String,AccountUserTerritory2View> ownMap = new Map<String,AccountUserTerritory2View>();
 		
            for(AccountUserTerritory2View ot : [SELECT AccountId,Id,userid,RoleInTerritory2,Territory2Id 
                                                FROM AccountUserTerritory2View where AccountId in : accounts and RoleInTerritory2 = 'Account Owner']){
                                                    ownMap.put(ot.AccountId,ot);
                                                }
        
        for(Account a:accToUpdate){
            if(ownMap.containsKey(a.Id)){AccountUserTerritory2View av = ownMap.get(a.Id);
                if(a.Ownerid != av.userid){a.Ownerid = av.userid;
                }
            }
        }         
         database.update (accToUpdate,false);
    }
    
}