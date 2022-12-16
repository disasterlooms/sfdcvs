public without sharing class SpaSearchBidDesk {
    
    //set the query paramaters to be used by different methods in this controller
    //only updating the pos line items, update not used for opportunities
    private ApexPages.StandardController controller {get; set;}
    public List<Quote> opps {get;set;}
    public String posreseller {get;set;}
    
    
    //the variables below are for mathching opportunities. Originally created for POS
    //matching, it became useful for other applications. Instead of separating the class
    //the classes will be used for either POS search, opp sear, opp updates.
    public String oppprod {get;set;}
    public String oppreseller {get;set;}
    public String industry {get;set;}
    public String prodtype {get;set;}
    public String oppenduser {get;set;}
    public String oppstate {get;set;}
    public String oppterritory {get;set;}
    public String oppcity {get;set;}
    public String oppowner {get;set;}
    public String spaid {get;set;}
    public Date oppcreatedatefrom {get;set;}
    public Date oppclosedateto {get;set;}
    public Date spaexpir {get;set;}
    public Integer i  {get;set;}
    
    
    public PageReference getspas()
    {
        //query all opportunities based on filtered criteria
        //first run query on the opp line items based on any criteria given
        
        String prodsearch = stringQuery.cleanString(oppprod);
        String enduser = stringQuery.cleanString(oppenduser);
        String res = stringQuery.cleanString(oppreseller);
        String state = stringQuery.cleanString(oppstate);
        String territory = stringQuery.cleanString(oppterritory);
        String city =  stringQuery.cleanString(oppcity);
        String owner =  stringQuery.cleanString(oppowner);
        String spa =  stringQuery.cleanString(spaid);
        
        String industry = stringQuery.cleanString(industry);
        String prodtype = stringQuery.cleanString(prodtype);
        
        // reseller = stringQuery.cleanString(reseller);
        
        
        List<QuoteLineItem> prods = [Select Product2.Name,Quote.OpportunityId,quote.Opportunity.Account.Name from QuoteLineItem
                                           where
                                           Product2.Name Like :prodsearch AND 
                                           Quote.Opportunity.Name Like :enduser
                                           AND (Quote.Opportunity.Spa_ID__c Like : spa or Quote.Opportunity.Name Like : spa)
                                           //And Opportunity.Owner.Name Like :owner AND CreatedDate > :oppcreatedatefrom
                                           AND (Quote.ExpirationDate > :  spaexpir OR Quote.ExpirationDate = null)
                                           And (Quote.Opportunity.Resellers_and_Type__c Like  : res OR Quote.Opportunity.Resellers_and_Type__c = null) 
                                           Order By  LastModifiedDate desc  NULLS last limit 4999];
        
        //get the products in a set based on the opportunity id and then query the opportunities that meet the 
        //criteria that is in the product list This ensures that we get opportunities whether or not it is filtered
        //by product sku or not
        Set<String> lines = new Set<String>();
        for(QuoteLineItem p : prods) lines.add(p.QuoteId);
        system.debug('products' +lines);
        system.debug('enduser: '+enduser); 
        system.debug('rese: '+res); 
        
        
        opps =                 [Select id, Name, Opportunity.Resellers_and_Type__c,Account.Name,Opportunity.Name,Status,First_Time_Buyer__c,ExpirationDate,
                                 Account.BillingCity,Account.BillingState,Bid_Registered__c,Spa_Request_Submitter__c , Spa_Request_Submitter__r.Name,
                                CreatedbyId,Createdby.Name, CreatedDate, Opportunity.CloseDate,Opportunity.StageName,OwnerId,Owner.LastName,
                                (Select Product2.Name from QuoteLineItems)
                                from Quote
                                Where
                                Id In: lines
                                AND Opportunity.Name Like :enduser
                                AND (Name Like : spa or Opportunity.Spa_Id__c Like : spa)
                                And (Opportunity.Resellers_and_Type__c Like  : res OR Opportunity.Resellers_and_Type__c = null)
                                order by ExpirationDate desc Limit 50 ]; 
        
        system.debug(opps);
        
        return null;
        
    }    
}