global class SpaStateSyncwithOpps implements Schedulable {
    global void execute(SchedulableContext ctx) {
        
         List<SpaStateSync__c> products = [Select PricbookEntryID__c ,OpportunityId__c ,Quantity__c ,Approved_Price__c, ApprovalDate__c  from SpaStateSync__c];
        
        Set<Id> opps = new Set<Id>();
        
        //neeed to de-duplicate any state spas that have multiple values
        
        Map<String, SpaStateSync__c> updatedprods = new Map<String, SpaStateSync__c>();
        for(SpaStateSync__c s : [Select PricbookEntryID__c ,OpportunityId__c ,Quantity__c ,Approved_Price__c, ApprovalDate__c  from SpaStateSync__c order by LastModifiedDate desc]){
            updatedprods.put(s.OpportunityId__c + s.PricbookEntryID__c, s);
           
        }
        //now that the map has deduped the list, put back in list to loop through and create the opportunity line items
        //
        List<SpaStateSync__c> prodsToAdd = new List<SpaStateSync__c>();
            for(SpaStateSync__c ds : updatedprods.values()){
                prodsToAdd.add(ds); 
            }
        
		system.debug('list of prods cleand');
		system.debug(prodsToAdd);
        
        Double price = 100;
        List<OpportunityLineItem> linesToInsert = new  List<OpportunityLineItem>();
        for(SpaStateSync__c s : prodsToAdd ){
             system.debug('approved price '+price+' quantity '+s.Quantity__c);
                OpportunityLineItem line = new OpportunityLineItem(Pricebookentryid = s.PricbookEntryID__c    , 
                                                                   opportunityId  =  s.OpportunityID__c,
                                                                   Quantity = s.Quantity__c,
                                                                   UnitPrice =  price,
                                                                   Approved_Price__c = s.Approved_Price__c,
                                                                   SPA_Approval_Date__c = s.ApprovalDate__c);
            linesToInsert.add(line);
            
        }     
        
        insert linesToInsert;
        system.debug('map dupe potential ');
        system.debug(updatedprods);
        system.debug('list');
        system.debug(linesToInsert);
        delete products;
    }
}