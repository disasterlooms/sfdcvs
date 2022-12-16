public class OppPackageProducts {
    @AuraEnabled
    public static void addRecords(String recid,List<Product_Package__c> packages,String quant){
        system.debug('rec id '+recid+' packages '+packages);
        Opportunity opp = [Select id, pricebook2id from opportunity where id =: recid];
        
        List<Package__c>  products = [Select id, Product__c, Product_Package__c  from Package__c 
                                      where Product_Package__c =: packages[0].Id];
        
        system.debug(products);
        system.debug('list of packagges');
        system.debug(quant+' quantity');
        
        Double quantity = double.valueOf(quant);
        
        List<OpportunityLineItem> lines = new List<OpportunityLineItem>();
        
        Map<String,PricebookEntry> pbe = new  Map<String,PricebookEntry> ();
        for(PricebookEntry p : [Select id, pricebook2Id, product2.name,unitprice,product2Id from PricebookEntry 
                                where isActive = true and pricebook2Id = : opp.pricebook2id])
            pbe.put(p.Product2Id, p);
        
        system.debug(pbe);
        for(Package__c p : products){
            system.debug(p.Product__c);
            system.debug('product for package');
            if(pbe.containsKey(p.Product__c)){
                PriceBookEntry entry = pbe.get(p.Product__c);
                OpportunityLineItem l = new OpportunityLineItem(OpportunityId = opp.Id,
                                                                UnitPrice = entry.UnitPrice,
                                                                Quantity = quantity,
                                                                pricebookentryid = entry.Id);
                lines.add(l);
                
            }
        }
        
        database.insert(lines,false);
        system.debug(lines);
    }
    @AuraEnabled
    public static void addLines(String recid,List<Product2> prods,String quant){
        system.debug('rec id '+recid+' prods '+prods);
        Opportunity opp = [Select id, pricebook2id from opportunity where id =: recid];
        
        List<Product2>  products = [Select id, name  from Product2 
                                      where Id = : prods[0].Id];
        
        if(quant == '' || quant == null){
            quant = '1';
        }
        system.debug(products);
        system.debug('list of packagges');
        system.debug(quant+' quantity');
        
        Double quantity = double.valueOf(quant);
        
        List<OpportunityLineItem> lines = new List<OpportunityLineItem>();
        
        Map<String,PricebookEntry> pbe = new  Map<String,PricebookEntry> ();
        for(PricebookEntry p : [Select id, pricebook2Id, product2.name,unitprice,product2Id from PricebookEntry 
                                where isActive = true and pricebook2Id = : opp.pricebook2id])
            pbe.put(p.Product2Id, p);
        
        system.debug(pbe);
        for(Product2 p : prods){
            system.debug(p.Id);
            system.debug('product for package');
            if(pbe.containsKey(p.Id)){
                PriceBookEntry entry = pbe.get(p.Id);
                OpportunityLineItem l = new OpportunityLineItem(OpportunityId = opp.Id,
                                                                UnitPrice = entry.UnitPrice,
                                                                Quantity = quantity,
                                                                pricebookentryid = entry.Id);
                lines.add(l);
                
            }
        }
        
        database.insert(lines,false);
        system.debug(lines);
        
        
    }
    @AuraEnabled
    public static void addQuoteLines(String recid,List<Product2> prods,String quant){
        system.debug('rec id '+recid+' prods '+prods);
        Quote opp = [Select id, pricebook2id from Quote where id =: recid];
        
        List<Product2>  products = [Select id, name  from Product2 
                                      where Id = : prods[0].Id];
        
        if(quant == '' || quant == null){
            quant = '1';
        }
        system.debug(products);
        system.debug('list of packagges');
        system.debug(quant+' quantity');
        
        Double quantity = double.valueOf(quant);
        
        List<QuoteLineItem> lines = new List<QuoteLineItem>();
        
        Map<String,PricebookEntry> pbe = new  Map<String,PricebookEntry> ();
        for(PricebookEntry p : [Select id, pricebook2Id, product2.name,unitprice,product2Id from PricebookEntry 
                                where isActive = true and pricebook2Id = : opp.pricebook2id])
            pbe.put(p.Product2Id, p);
        
        system.debug(pbe);
        for(Product2 p : prods){
            system.debug(p.Id);
            system.debug('product for package');
            if(pbe.containsKey(p.Id)){
                PriceBookEntry entry = pbe.get(p.Id);
                QuoteLineItem l = new QuoteLineItem(QuoteId = opp.Id,
                                                                UnitPrice = entry.UnitPrice,
                                                                Quantity = quantity,
                                                                pricebookentryid = entry.Id);
                lines.add(l);
                
            }
        }
        
        database.insert(lines,false);
        system.debug(lines);
        
        
    }
}