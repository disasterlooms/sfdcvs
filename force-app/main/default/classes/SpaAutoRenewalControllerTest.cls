@isTest
public class SpaAutoRenewalControllerTest {
    @testSetup
    public static void createdata ()
    {
        BuildTestData.AddRecords();
        
    }
    //comment nothing
    static testMethod void getUpdatedQuoteTest() { 
        test.startTest();
        //Quote q=[select id from Quote where spa_Request_type__c ='Spa Request' limit 1];
        opportunity opp=[select id,spa_id__c from opportunity limit 1];
        quote q=new quote(opportunityId=opp.id,
                          spa_Request_type__c='Spa Request',
                          name='apex test');
        
        insert q;
        SpaAutoRenewalController.getUpdatedQuote('test',q.id);
    }
    
}