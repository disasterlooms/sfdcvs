global class posResellerPYsch implements Schedulable {
    global void execute(SchedulableContext ctx) {
        posResellerPYschFuture.updatePYRevenue();
        
        
    }    
}