public class quoteResellerGetProducts {
 	public Id accId {get;set;}
    public List<Opportunity_Partner__c> parts {get;set;}
    public List<OpportunityLineItem> getCons() {
        List<OpportunityLineItem> cons = [select id, product2.name,quantity,unitprice,Product2.Description,
                                    SPA_Expiration_Date__c,Product2.Bundle__c,SPA_Approval_Date__c,
               Product2.family from OpportunityLineItem where OpportunityId =: accId and Likely_Purchase__c  = true];
        
         parts = [select id, partner_account__r.Name from Opportunity_Partner__c where Opportunity__c =: accId
                                             and Partner_Type__c = 'Distributor'];
        
        //(select id, partner_account__r.Name from Opportunity_Partners__c where Partner_Type__c = 'Distributor' )

         return cons;        
    }
    
}