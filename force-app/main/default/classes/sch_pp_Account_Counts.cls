global class sch_pp_Account_Counts implements Schedulable {
    global void execute(SchedulableContext ctx) {
        //This schedule batch counts the amount contacts, contacts in program, and contacts active in 
        //program 
        batch_pp_AccountCounts b = new batch_pp_AccountCounts(); 
        database.executebatch(b,50);
        
        /*
        batch_pp_Account_Enrolled enrolled = new batch_pp_Account_Enrolled(); 
        database.executebatch(enrolled,50);   
        
        batch_pp_Account_ActiveEnrolled active = new batch_pp_Account_ActiveEnrolled(); 
        database.executebatch(active,50);
        */
        
    }
    
}