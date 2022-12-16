public class GovSpendContactComponentController {
	
    @AuraEnabled
    public static void doMappingSync(String searchId) {
        //GovSpendMappingService.handleSearch('62e3ad68a7dc040031419e1e');
       // System.enqueueJob(new GovSpendCalloutQueueable());
      GovSpendMappingService.handleSearch(searchId);
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getCredits(String searchId){
        ExportCreditStats ecs = GovSpendMappingService.getCreditStats(searchId);
        Map<String, Object> returnMap = new Map<String, Object>();
        returnMap.put('totalRecords',ecs.totalRecords);
        return returnMap;
    }

    
}