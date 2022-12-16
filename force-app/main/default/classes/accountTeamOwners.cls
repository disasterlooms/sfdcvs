global class accountTeamOwners implements 
Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        //This will batch class will run after running territory rules update 
        //via a web callout.. then this will look at accounts that are not aligned properly
        //and update the account and contact ownership.
        
        
        return Database.getQueryLocator(
            'select id,ownerId,TerritoryChange__c from Account where TerritoryChange__c = true'
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accts){
        // process each batch of records for accounts queried
        // need to find where account was changed to a point as
        // to change account owner and/or team. this team is used for spa
        // teams and email distribution of spas so that the proper reps are notified
        // of any spa changes .. bid desk can update the team, but they may miss that
        // step and we are working towards reducing that need. 
        // 
        // There are  use cases where account ownership should change
        // 
        // 1. Data in the account now lines up to a different owner 
        // 2. Terrritory Rules are updated .. Update due to business needs or a correction
        // This batch resolves 1.. I chose to take out of trigger because it was not operating
        // as expected. Instead going through batch as it is more scalable. We do have user
        // actions that can trigger a change, but not on a system trigger, instead it is on a button. 
        // All Owner updates around the same code, except for Spa Team as this is needed to send out a 
        // spa and a delay is too disruptive.
        // 
        // 
        Set<String> acts = new Set<String>();
        
        Boolean runrules = false;
        
        List <Account> acctrunrules = [Select id, RunTerritoryRules__c from Account where RunTerritoryRules__c = true and  id in: accts];
        
        for(Account a : acctrunrules){
            acts.add(a.Id);
        }
        system.debug('accts');
        system.debug(acts);
        if(!Test.isRunningTest()&&acts.size()>0){ID jobID = System.enqueueJob(new RunTerritoryRules(acts));}
        
        system.debug('is a test? '+Test.isRunningTest());
        
        Map<Id,List<AccountUserTerritory2View>> acctteam = new Map<Id,List<AccountUserTerritory2View>>();   
        Map<String, AccountUserTerritory2View > acctowner = new Map<String , AccountUserTerritory2View >();
        
        List<AccountUserTerritory2View> AcctTer = [Select AccountId,UserId,Territory2Id,User.Name,RoleInTerritory2 from AccountUserTerritory2View  where Accountid in : accts
                                                    order by AccountId];
        
        for( AccountUserTerritory2View  aut : AcctTer){
            
            List<AccountUserTerritory2View> entitiesForKey = acctteam.get(aut.AccountId);
            if(aut.RoleInTerritory2 == 'Account Owner'){
                 acctowner.put(aut.AccountId, aut);
            }
            
            if (entitiesForKey == null) {
                entitiesForKey = new List<AccountUserTerritory2View>();
                acctteam.put(aut.AccountId, entitiesForKey);
               
            }
            entitiesForKey.add(aut);}
        
        system.debug('acct team map list ');
        system.debug(acctteam); 
        
        List<Account> acctsUpdate = new List<Account>();
        List<AccountTeamMember> aTeamInsert = new List<AccountTeamMember>(); 
        for(Account a : accts){
            if(acctowner.containsKey(a.Id)){
                AccountUserTerritory2View own = acctowner.get(a.Id);
                a.TerritoryChange__c = false;
                a.OwnerId = own.UserId;
                acctsUpdate.add(a);
            }             
            if(acctteam.containsKey(a.Id)){
                List<AccountUserTerritory2View> ateam = acctteam.get(a.Id);for(AccountUserTerritory2View  aut : ateam){aTeamInsert.add(new AccountTeamMember(AccountId = a.Id,AccountAccessLevel='Edit',CaseAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='Edit',TeamMemberRole = aut.RoleInTerritory2,UserId = aut.UserId));}}
        }
        
        database.update(acctsUpdate, false);
        List<AccountTeamMember> aTeamToDelte = [Select id,AccountId from AccountTeamMember where Accountid in :acctsUpdate];
        delete aTeamToDelte;
        database.insert(aTeamInsert,false); 
        
    }    
    
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. disaster averted!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        system.debug(job);
    }    
    
}