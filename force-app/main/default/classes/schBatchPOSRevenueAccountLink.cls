global class schBatchPOSRevenueAccountLink implements Schedulable {
    global void execute(SchedulableContext ctx) {
        
        batchPOSRevenueAccountLinks b = new batchPOSRevenueAccountLinks(); 
        database.executebatch(b,100);       
        
    }
    
}