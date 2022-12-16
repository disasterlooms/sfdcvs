public class GovSpendCalloutQueueable implements Queueable, Database.AllowsCallouts {
    
    String searchId;
    Integer pageNumber;
    Integer totalPages;
    String jobId;
    
    public GovSpendCalloutQueueable(String searchId, Integer pageNumber, Integer totalPages, String jobId){
        this.searchId=searchId;
        this.pageNumber=pageNumber;
        this.totalPages=totalPages;
        this.jobId = jobId;
    }
    
   // public GovSpendCalloutQueueable(){}
    
    public void execute(QueueableContext context) {
		GovSpendMappingService.doMapping(searchId, pageNumber, totalPages, jobId);
        if(this.pageNumber!=this.totalPages){
            System.enqueueJob(new GovSpendCalloutQueueable(this.searchId, pageNumber+1, this.totalPages, jobId));
        }
    }
}