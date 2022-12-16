global class posPYsch implements Schedulable {
    global void execute(SchedulableContext ctx) {
        posPYschFuture.updatePYRevenue();
        
        
    }    
}