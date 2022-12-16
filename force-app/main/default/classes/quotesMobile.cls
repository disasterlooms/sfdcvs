public class quotesMobile {
    @AuraEnabled
    public static List<Quote> getSpas(String searchtxt){
        
        system.debug('Search given '+searchtxt);       
        
        String srchtxt = '%'+searchtxt+'%';
        system.debug('search like stm '+srchtxt);        
        
        List<Quote> quotes = [Select id,name,expirationdate,account.name,resellers__c,
                              opportunity.name,
                              bid_registered__c,status,(select product2.name from quotelineitems)
                              from quote where (account.name like : srchtxt or name like : srchtxt
                              or resellers__c like : srchtxt) and status != 'Inactive' 
                              order by expirationdate desc limit 300 ];        
        
        system.debug('quotes found');
        system.debug(quotes);
        return quotes;
        
    }
}