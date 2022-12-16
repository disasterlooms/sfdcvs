global class accountTeamOwnersSchd implements Schedulable {
    global void execute(SchedulableContext ctx) {
        accountTeamOwners b = new accountTeamOwners(); 
        database.executebatch(b);       
        
    }
    
}