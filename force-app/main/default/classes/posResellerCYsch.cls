global class posResellerCYsch implements Schedulable {
    global void execute(SchedulableContext ctx) {
       posResellerCYschFuture.updateCYRevenue();       
    }    
}