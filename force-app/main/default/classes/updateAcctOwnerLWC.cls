public without sharing class updateAcctOwnerLWC {
    @AuraEnabled(cacheable=true)
    public static String getCorrectOwner(String acctId) {
        system.debug('acct id '+ acctId);
        String updated = 'Not Checked';
        Account a = [Select id, ownerid,ownerUpdateAttempt__c from account where id =: acctId limit 1];
        if(a.ownerUpdateAttempt__c){
            return updated;
        }        
        Set<String> records = new Set<String> ();
        records.add(acctId);
        if(!Test.isRunningTest()){
           // System.enqueueJob(new RunTerritoryRules(records));   
        }
        Map<String,AccountUserTerritory2View> ownMap = new Map<String,AccountUserTerritory2View>();

        for(AccountUserTerritory2View ot : [SELECT AccountId,Id,userid,RoleInTerritory2,Territory2Id 
        FROM AccountUserTerritory2View where AccountId =: acctId and RoleInTerritory2 = 'Account Owner']){
        ownMap.put(ot.AccountId,ot);
        }

       
            if(ownMap.containsKey(a.Id)){
            AccountUserTerritory2View av = ownMap.get(a.Id);
                if(a.Ownerid != av.userid){
                    updated = av.userid;
                    a.Ownerid = av.userid;
                    
                
                }else{
                    updated = 'Owner matches Rules';
                }
            }else{
                updated = 'No Owner Found';
            }

        return updated;
    }
}