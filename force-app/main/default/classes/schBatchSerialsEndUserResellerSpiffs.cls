global class schBatchSerialsEndUserResellerSpiffs implements Schedulable {
    global void execute(SchedulableContext ctx) {        
        bathSerialsEndUserResellerSpiffs b = new bathSerialsEndUserResellerSpiffs(); 
        database.executebatch(b,50);               
    }
    
}