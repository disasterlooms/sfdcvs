global class QuoteNewPriceBook {
    @InvocableMethod
    public static List<String> ChangePB(List<String> pboppid) {
        String oppid ='';
        String pbid ='';
        system.debug('pboppid '+pboppid);
        for(String o: pboppid){
            oppid = o.substring(0, 18);
            pbid = o.substring(19, 37);
        }
        system.debug('opid '+oppid);
        system.debug('pbid '+pbid);
        List<OpportunityLineItem> opplines = [Select Id from OpportunityLineItem
                                              where opportunityid = : oppid ];
		
        
        
        Set<String> prodids = new Set<String>();
        
        Map<String, OpportunityLineItem> products = new Map<String,OpportunityLineItem>();
        
        for(OpportunityLineItem op : [Select Id, product2Id,quantity,opportunityid, opportunity.pricebook2id from OpportunityLineItem
                                      where opportunityid = : oppid ])
        {
            products.put(op.Product2Id,op);
            prodids.add(op.Product2Id);  
        }
        
        //have to delete quote and opp line items before creating new pricebook id and new line items
        List<Quote> quote = [Select id from Quote where opportunityId = : oppid];
        delete quote;
        delete opplines;
        
        Opportunity opp = [Select Id,pricebook2id,Spa_Id__c,country__c from opportunity where id =: oppid];
        
        opp.pricebook2id = pbid;
        update opp;

        
        List<Pricebookentry> pbes = [Select Id,UnitPrice,Product2Id from Pricebookentry where 
                                     product2Id in: prodids and pricebook2id =: pbid and isactive = true];
        
        List<OpportunityLineItem> linestoinsert = new List<OpportunityLineItem>();
        Double quant = 1;
        
        
        for(Pricebookentry e : pbes){
            OpportunityLineItem ol = products.get(e.Product2Id);
            //ensure quantity is not zero. if so, use 1
            if(ol.Quantity > 0){
                quant = ol.Quantity;
            }
            
            OpportunityLineItem nl = new OpportunityLineItem(OpportunityId = oppid,
                                                             Quantity=quant,
                                                             UnitPrice= e.UnitPrice,
                                                             pricebookentryid = e.Id);
            linestoinsert.add(nl);
        }
        
        List<Account> distis = [SELECT Id,Name,BillingCountry FROM Account where BillingCountry =: opp.Country__c AND Auto_Create_Disti__c = true] ;
        system.debug('queried distributors ' +distis);
        
        List<AccountTeamMember> distiacctteam = [SELECT Id,UserId,AccountId,Account.BillingCountry,TeamMemberRole FROM AccountTeamMember where AccountId In:distis] ;
        List<Opportunity_Partner__c> partstoinsert = new List<Opportunity_Partner__c>();
         for (Account a : distis){
             if(opp.Pricebook2Id == '01sA00000008gzSIAQ' || opp.Pricebook2Id == '01sA00000008gzXIAQ'){
                 Opportunity_Partner__c distipart = new Opportunity_Partner__c(
                            Opportunity__c = opp.id, 
                            Partner_Type__c = 'Distributor',
                            Partner_Account__c = a.Id );
                        partstoinsert.add(distipart);
             }   
         }
        
        insert partstoinsert;
        opp.pricebook2id = pbid;
        update opp;
        
        
        
        insert linestoinsert;
        
        system.debug(products+' pbes');
        
        Quote q = new Quote(OpportunityId=opp.Id,
                            name= opp.Spa_Id__c,
                            status= 'Needs Review');
        insert q;
        
        List<Id> quotids = new List<Id>();
        quotids.add(q.Id);
        
        return quotids;
        
    }
}