public class AcctAggrPOSSerial {
    public static void getSummary(){
        
        PosDates__mdt pos = [Select FromDays__c  from PosDates__mdt limit 1];
        
        Integer days = pos.FromDays__c.intValue();
        system.debug(pos.FromDays__c);
        Date fromdate = date.today().addDays(days);
        system.debug('days');
        system.debug(fromdate);
        
        AggregateResult[] accsrev = [SELECT AccountId, sum(Price) prc,count(Id) cnt,max(PurchaseDate) pdate 
                                     FROM Asset  where PurchaseDate >= :fromdate GROUP BY AccountId];      
              
        system.debug('ag res');
        system.debug(accsrev);
        List<Account> accts = new List<Account>();
        
        for(AggregateResult ar : accsrev){
             Account a = new Account();
             a.Id = (Id)ar.get('AccountId');
             a.SalesRevCurrent_Week__c = (Decimal)ar.get('prc');
             a.LastSaleWeek__c = (Date)ar.get('pdate');
             a.QtyLastSaleWeek__c  = (Integer)ar.get('cnt');
             accts.add(a);
        }
        system.debug('accts ');
        system.debug(accts);
        system.debug(accts.size());
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.AllowSave = true;
        dml.OptAllOrNone = false;        
        database.update (accts,dml);
    }

}