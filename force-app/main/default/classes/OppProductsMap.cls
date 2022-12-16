public class OppProductsMap {
    public static Map<String, OpportunityLineItem> getLineMap(List<QuoteLineItem> qlines){
        
       Set<String> opps = new Set<String>();
       Set<String> prods = new Set<String>();
        
        for(QuoteLineItem q : qlines){
            opps.add(q.OpportunityId__c);
            prods.add(q.Product2Id);
        }            
        
		//This class is for state sync spas. using map that concates both product2id and opp id just in case 
		//we add code that needs to sync other information and there is an insert that has more than one opportunity
		//with multiple quote line items 
		        
        Map<String,OpportunityLineItem> oproducts = new Map<String,OpportunityLineItem>();
        for(OpportunityLineItem p : [Select Id, OpportunityId,SPA_Approval_Date__c ,quantity,Likely_Purchase__c,unitprice,pricebookentry.isactive, product2Id from opportunitylineitem where opportunityid in: opps
                                       and product2id in: prods and pricebookentry.isactive = true])
            oproducts.put( String.valueOf(p.OpportunityId) + String.valueOf(p.Product2Id) , p);
        
        return oproducts;
        
    }

}