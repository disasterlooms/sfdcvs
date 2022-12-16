global class SchAcctAggrPOSSerial implements Schedulable {
    global void execute(SchedulableContext ctx) {
        
        AcctAggrPOSSerial.getSummary();
    }
    
}