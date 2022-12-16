public class OppQuote {    
    @AuraEnabled
    public static Opportunity getSpas(String recid)
    {
      Opportunity opp = [Select id, name,Spa_Id__c,PriceBook2Id from Opportunity where id =:recid limit 1];
      
        system.debug(opp);
      return opp;  
    }
}