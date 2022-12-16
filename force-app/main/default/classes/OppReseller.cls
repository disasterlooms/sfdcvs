public class OppReseller {
    @AuraEnabled
    public static String getReseller(String recid)
    { 
        String resellerstatus = 'Reseller has been added. This will refresh the page';
        Opportunity opp = [Select id, Partner_Account_Search__c , ResellerContact__c from 
                           Opportunity where id = : recid];
        
        
        Opportunity_Partner__c partsToInsert = new Opportunity_Partner__c(opportunity__c = opp.Id,
                                                                          partner_account__c = opp.Partner_Account_Search__c,
                                                                          Partner_Type__c = 'Reseller / VAR',
                                                                          Reseller_Contact__c = opp.ResellerContact__c);
        insert partsToInsert;
        system.debug(partsToInsert);
        return resellerstatus;     
        
    }
}