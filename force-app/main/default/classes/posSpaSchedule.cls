global class posSpaSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        
        PosSpaBatch b = new PosSpaBatch(); 
        database.executebatch(b);       
        
    }
    
}