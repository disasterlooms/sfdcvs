global class schAssetAccountRevenue implements Schedulable {
    global void execute(SchedulableContext ctx) {
        
        BatchQuery__mdt  q = [select id,fromDate__c , toDate__c, batchNumber__c  from BatchQuery__mdt   where BatchClass__c  = 'assetAccountReveneBch' limit 1];
        Integer batchSize = Integer.valueOf(q.batchNumber__c)  ; 
        
        assetAccountReveneBch b = new assetAccountReveneBch(); 
        database.executebatch(b,batchSize);
        
        assetResellerRevenueBatch bres = new assetResellerRevenueBatch(); 
        database.executebatch(bres,batchSize);        
        
    }
    
}