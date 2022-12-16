@isTest 
public class AnyRecordUnlockCMPControllerTest {
    @testSetup
    public static void createdata ()
    {
        BuildTestData.AddRecords();
        
    }
    
    static testMethod void getUpdatedRecordTest() { 
        test.startTest();
        opportunity opp=[select id,spa_id__c from opportunity limit 1];
        quote q=new quote(opportunityId=opp.id,
                          spa_Request_type__c='Spa Request',
                          name='apex test');
        
        insert q;
        AnyRecordUnlockCMPController.getUnclockRecord(q.id);
        
        Quote q1 = [select id,record_is_locked__c from Quote where id =:q.id];
        test.stopTest();
        system.assertEquals(false, q.record_is_locked__c);
        
        
    }
    
    
    
}