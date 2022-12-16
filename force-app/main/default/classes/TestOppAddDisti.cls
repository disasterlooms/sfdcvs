@isTest
public class TestOppAddDisti {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void getDistis()
    {
        test.startTest();
        Opportunity opp = [Select id from opportunity limit 1];
        String recid = opp.id;
        List <Account> accts = oppadddistis.getDistis(recid);
        
        List<Opportunity_Partner__c> distis = new List< Opportunity_Partner__c>();
        for(Account a : accts){
            Opportunity_Partner__c ops = new Opportunity_Partner__c(partner_account__c = a.id,
                                                                    opportunity__c = opp.Id,
                                                                    Partner_Type__c = 'Distributor');
            distis.add(ops);
        }
	     
        oppadddistis.addDistis(distis);
        
        test.stopTest();
        
        
    }	


}