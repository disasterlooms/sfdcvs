@isTest 
public class UpdateSpaControllerTest {
     @testSetup
    public static void createdata ()
    {
        BuildTestData.AddRecords();
        
    }
    static testMethod void getUpdatedRecordTest() { 
        test.startTest();
        //Quote q=[select id from Quote where spa_Request_type__c ='Spa Request' limit 1];
     opportunity opp=[select id,spa_id__c from opportunity limit 1];
        quote q=new quote(opportunityId=opp.id,
                         spa_Request_type__c='Spa Request',
                         name='apex test');
        
        insert q;
        
        
        String currentRecord=q.id;
        String WorkActivity='testworkactivittyjlkfj';
        String ScopeOfBidRegistration='test workactiv itt yjlkfj';
        String BusinessReasonforBidRegistration='test workactiv itt yjlkfj';
        
        UpdateSpaController.getQuoteDetails(currentRecord);
        UpdateSpaController.getUpdatedRecord(currentRecord, WorkActivity, ScopeOfBidRegistration, BusinessReasonforBidRegistration);  
        
        //WorkActivity='';
        
        //UpdateSpaController.getUpdatedRecord(currentRecord, WorkActivity, ScopeOfBidRegistration, BusinessReasonforBidRegistration);
        //
       // Quote q1=[select id, Locked from Quote where id=:q.id limit 1];
        test.stopTest();
        
        /*   createdata ();
Quote testingquote = [select id,Spa_Request_Type__c,Business_Reason_for_Bid_Registration__c,OpportunityId__c,Scope_of_Bid_Registration__c, List_of_Work_Activity_c__c  from Quote where name='apext test'];
UpdateSpaController.getUpdatedRecord(testingquote.id,'WorkActivity', 'ScopeOfBidRegistrationtest', 'BusinessReasonforBidRegistrationtesssss');*/
    }   
    
}