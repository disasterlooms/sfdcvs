global class posCYsch implements Schedulable {
    global void execute(SchedulableContext ctx) {
       posCYschFuture.updateCYRevenue();       
    }    
}