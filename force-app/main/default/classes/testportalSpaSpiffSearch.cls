@isTest
public class testportalSpaSpiffSearch  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void testSpiffSpaSearch() {
        test.startTest();
        
        String spaName = '';
        
        Opportunity opp = [Select Account.Id, id, (Select id,partner_account__r.name from Opportunity_partners__r) from opportunity 
                           where id in (select opportunity__c from Opportunity_partner__c) limit 1];
        
        
        Quote q = new Quote();
        q.opportunityId = opp.Id;
        q.name = '1234';
        q.Status = 'Needs Review';
        insert q;
        
        system.debug('opp info ');
        system.debug(opp.Opportunity_partners__r);

        portalSpaSpiffSearch.getSpas(q.name);
        
        
        
        test.stopTest();
        
    }
}