global class UpdateOppLineMargins implements Schedulable {

    global void execute(SchedulableContext ctx) {
         UpdateOppLineItems myBatchObject = new UpdateOppLineItems(); 
         Id batchId = Database.executeBatch(myBatchObject);   
    }
    
}