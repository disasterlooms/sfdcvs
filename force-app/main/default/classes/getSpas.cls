public class getSpas {
    @AuraEnabled
    public static List<Quote> getspas(String quoteid){
        system.debug('quoteid '+ quoteid);
        //get a list of sibling spas that are related to the opportunity
        List<Opportunity> opps = [select id, 
                                  (Select id , name, status, expirationdate,Bid_Registered__c,Specialty_Spa__c,Recent_Approval_Date__c from quotes where id != : quoteid) 
                               from opportunity where Id in (Select OpportunityId from Quote where id =: quoteid) limit 1];
        
        List<Quote> records = opps[0].Quotes;
        
        
        System.debug( records );
        
        return records;
    }
}