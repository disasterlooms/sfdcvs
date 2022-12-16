global class OppLineItemMonthlySchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        OppScheduleNewMonth b = new OppScheduleNewMonth(); 
        database.executebatch(b);       
        
    }
    
}