global class schedTerritoryRules implements Schedulable {
    global void execute(SchedulableContext ctx) {        
        Datetime yest = datetime.now()-1;
		Set<String> acts = new Set<String>();
        List<Account> accts = [Select id from account where lastmodifieddate > : yest limit 9999];
        
        for(Account a : accts){
            acts.add(a.Id);
        }
		system.debug('accts');
        system.debug(acts);
        system.debug(yest);         
        system.debug('is a test? '+Test.isRunningTest());
        if(!Test.isRunningTest()){System.enqueueJob(new RunTerritoryRules(acts));}
        
    }
}