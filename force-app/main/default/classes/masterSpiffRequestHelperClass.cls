public class masterSpiffRequestHelperClass{
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Spiff_Request__c > oldspiffs;
    Map<Id, Spiff_Request__c > newspiffs;
    
    
    public masterSpiffRequestHelperClass(
        Map<Id, Spiff_Request__c > oldTriggerspiffs, 
        Map<Id, Spiff_Request__c > newTriggerspiffs) {
            oldspiffs = oldTriggerspiffs;
            newspiffs = newTriggerspiffs;
        }
    
     public static void endUserMap(List<Spiff_Request__c> records) {
        
         Map<String,Contact> cons = new Map<String,Contact>();
         Set<String> conSearch = new Set<String>();
         for(Spiff_request__c s : records){
             if(s.Requester_Company__c == null){
                 conSearch.add(s.Requester__c);
             }             
         }
         for(Contact c : [Select id, accountId from contact where id in: conSearch]){
             cons.put(c.Id, c);
         }
         
         for(Spiff_request__c s : records){
             if(cons.containsKey(s.Requester__c)){
                 Contact c = cons.get(s.Requester__c);
                 s.Requester_Company__c = c.AccountId;
             }             
         }
         
        
         
     }
    public static void newSpiff(List<Spiff_Request__c> records) {
        //check if contact exist
        
         Set<String> spas = new Set<String>();
         Set<String> prods = new Set<String>();
        
        List<Contact> consToInsert = new List<Contact>();
        
        Set<String> conEmails = new Set<String>();
        for(Spiff_Request__c s : records){
            spas.add(s.Spa_Number__c);
             prods.add(s.Product__c);				            
            if(s.End_User_Email__c != null && s.End_User_Email__c != ''){
                conEmails.add(s.End_User_Email__c);
            }            
        }
        
        Map<String,QuoteLineItem> lines = new Map<String,QuoteLineItem>();
        for(QuoteLineItem q : [Select id, quote.name, Product2Id from quotelineitem where Product2Id in : prods
                               and quote.name in : spas order by quote.expirationdate desc]){
                                   String quoteId = q.quote.name+q.Product2Id;
                                   lines.put(quoteId,q);                                   
                               }
        
        
        Map<String,Contact> conIds = new Map<String,Contact>();
        for(Contact c : [Select id,email from contact where email in : conEmails]){
            conIds.put(c.Email,c);
        }
        
        for(Spiff_Request__c s : records){
            String spiffKey = s.Spa_Number__c+s.Product__c;
            if(lines.containsKey(spiffKey)){
                Quotelineitem ql = lines.get(spiffKey);
                s.Spa_Product__c = ql.Id;
            }
            
            
            if(conIds.containsKey(s.End_User_Email__c)){
                Contact ct = conIds.get(s.End_User_Email__c);
                s.End_User_Contact__c = ct.Id;
            }else{
                Contact con = new Contact();
                con.AccountId = s.End_User__c;
                con.Email = s.End_User_Email__c;
                con.FirstName = s.End_User_Contact_Name__c;
                con.LastName = s.End_User_Contact_Last_Name__c ;                
                consToInsert.add(con);
            }
            
        }
        database.insert(consToInsert,false);
        
        Map<String,Contact> conIds2 = new Map<String,Contact>();
        for(Contact c : [Select id,email from contact where email in : conEmails]){
            conIds2.put(c.Email,c);
        }
        system.debug('emails '+ conIds2);
        for(Spiff_Request__c s : records){
            system.debug('looping through spissf');
            system.debug('email '+ s.End_User_Email__c+ ' end user conid '+ s.End_User_Contact__c);            
            if(s.End_User_Email__c != null){
                if(conIds2.containsKey(s.End_User_Email__c.toLowerCase()) && s.End_User_Contact__c == null){
                    system.debug('passed test');
                    Contact ct = conIds2.get(s.End_User_Email__c.toLowerCase());
                    s.End_User_Contact__c = ct.Id;
                } 
            }
            
            
        }
    }
    
    public static void getSpiffPromotional(List<Spiff_Request__c> records) {
        
        List<Spiff_Request__c> spiffToUpdate = new List<Spiff_Request__c>();
        spiffToUpdate = [Select Id, Requester__r.accountid,Requester__r.account.billingcountry,Requester__r.account.billingcountrycode, Requester__r.Account.partner_incentive_type__c,
                         Requester__r.Account.spiff_type__c,Product__r.Name from Spiff_Request__c where id in: records];
        
        
        
        
        /*
String billCountry = con.Account.BillingCountry;
String SpiffType = con.Account.spiff_type__c;
String IncentiveType = con.Account.partner_incentive_type__c;
*/
        
        PricingEffectiveDate__c effDate = [Select Effective_Date__c from PricingEffectiveDate__c where name 
                                           = 'PricingDate' limit 1];
        /*
pp = [Select id, Spiff_Amount__c,product__c from Portal_Pricing__c where Effective_Date__c = : effDate.Effective_Date__c and Spiff_Amount__c > 0 
and Country__c =: billCountry and Partner_Incentive_Type__c =: IncentiveType and  Spiff_Type__c = : SpiffType and product__c like: prod
order by product__c]; 

*/
        Map<String,Portal_Pricing__c> pricing = new Map<String,Portal_Pricing__c>();
        for(Portal_Pricing__c pp : [Select id, Spiff_Amount__c,product__c,Partner_Incentive_Type__c, Country__c,
                                     Spiff_Type__c from Portal_Pricing__c where Effective_Date__c = : effDate.Effective_Date__c]){
                                         String mapString = pp.product__c+ pp.Country__c+ pp.Spiff_Type__c+ pp.Partner_Incentive_Type__c;
                                         pricing.put(mapString,pp);
            
            
        }
        
        for(Spiff_Request__c s: spiffToUpdate){
            if(pricing.containsKey(s.Product__r.Name+s.Requester__r.account.billingcountry+s.Requester__r.Account.spiff_type__c+s.Requester__r.Account.partner_incentive_type__c)) {
                Portal_Pricing__c p = pricing.get(s.Product__r.Name+s.Requester__r.account.billingcountry+s.Requester__r.Account.spiff_type__c+s.Requester__r.Account.partner_incentive_type__c);
                s.Per_Unit_Spiff__c = p.Spiff_Amount__c;
            }            
            
        }
        update spiffToUpdate;
        
        
        
    }
    
}