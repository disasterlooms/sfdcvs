public class AccountTeamAdd {
    
    // The one method your master trigger will call
    Public static List<AccountTeamMember> teams(List<Account> accs) {
         system.debug('acct team add running');        
        //so here we go...so fun... Getting a list of Users relating to the territory for the accounts in this trigger
        //A list of users for each account is added to the map so that we can add those users to the account team
        //We need the account team because current 10.15.2018 opportunity and spa teams are pulled from account teams. 
        //if we get the account team right, we will have the correct opportunity team. The opportunity team 
        //is used for spa emails.. 
        //
       //  We will not update account teams when there is a suppression for such
        
        List<Account> accts = [Select Id, OwnerId,TerritoryChange__c  from Account where id in: accs and DoNotUpdateAcctTeam__C = false];
        /*
        Set<String> acts = new Set<String>();
        
        for(Account a : accts){
            acts.add(a.Id);
        }
        system.debug('accts');
        system.debug(acts);
        if(!Test.isRunningTest()){RunTerritoryRules job = new RunTerritoryRules() ;job.accntIds = acts;ID jobID = System.enqueueJob(job);}
        */
        
        
        List<AccountTeamMember> aTeamToDelte = [Select id,AccountId from AccountTeamMember where Accountid in :accts and  Account.DoNotUpdateAcctTeam__C = false];
        database.delete(aTeamToDelte,false);
        
        Map<Id,List<AccountUserTerritory2View>> acctteam = new Map<Id,List<AccountUserTerritory2View>>();   
        Map<String, AccountUserTerritory2View > acctowner = new Map<String , AccountUserTerritory2View >();
        
        List<AccountUserTerritory2View> AcctTer = [Select AccountId,UserId,Territory2Id,User.Name,RoleInTerritory2 from AccountUserTerritory2View  where Accountid in : accts
                                                   order by AccountId];
         
        
        for( AccountUserTerritory2View  aut : AcctTer){
            if( aut.RoleInTerritory2 =='Account Owner'){acctowner.put(aut.AccountId, aut); }
           
            List<AccountUserTerritory2View> entitiesForKey = acctteam.get(aut.AccountId);if (entitiesForKey == null) {entitiesForKey = new List<AccountUserTerritory2View>();acctteam.put(aut.AccountId, entitiesForKey);}entitiesForKey.add(aut);
        }
        
        system.debug('acct team map list ');
        system.debug(acctteam); 
        
        
        List<AccountTeamMember> aTeamInsert = new List<AccountTeamMember>();      
       system.debug('acctwoner map');
       system.debug(acctowner);
       for(Account a : accts){
            if(acctowner.containsKey(a.Id)){AccountUserTerritory2View own = acctowner.get(a.Id);a.TerritoryChange__c = false;a.OwnerId = own.UserId;a.TerritoryChange__c  = true;} 
       }
        try{
            update accts;
        }catch(Exception e){
            String recId = accts[0].Id;String objType  ='AccountTeamMember';String apexClass ='AccountTeamAdd update accts line 54'; String errMessage = e.getmessage(); apexerrorlog.logError(recId, objType, apexClass, errMessage);
           
             database.update(accts, false);
        } 
        
       
        system.debug('update accts');
        system.debug(accts);
        
        for(Account a : accts){
            if(acctteam.containsKey(a.Id)){
                List<AccountUserTerritory2View> ateam = acctteam.get(a.Id);for(AccountUserTerritory2View  aut : ateam){aTeamInsert.add(new AccountTeamMember(AccountId = a.Id,AccountAccessLevel='Edit',CaseAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='Edit',TeamMemberRole = aut.RoleInTerritory2,UserId = aut.UserId));}}
		
            
        }
         try{
            insert aTeamInsert;
        }catch(Exception e){
            String recId = aTeamInsert[0].AccountId;String objType  ='AccountTeamMember';String apexClass ='AccountTeamAdd line ateams insert 74'; String errMessage = e.getmessage(); apexerrorlog.logError(recId, objType, apexClass, errMessage);
           
            database.insert(aTeamInsert,false);
        } 
        
        
        List<AccountTeamMember> acctTeams = [Select id,AccountId, TeamMemberRole , userId from AccountTeamMember where Accountid in : accs];
        system.debug(acctTeams.size());
        system.debug(acctTeams);
        system.debug('Entire Acct team from AccountTeamAdd');
        return acctTeams;
        
    }
}