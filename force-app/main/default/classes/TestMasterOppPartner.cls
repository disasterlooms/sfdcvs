@IsTest
public class TestMasterOppPartner  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void MasterOppInsert() {
        TriggerContextUtility.setFirstRunFalse();    
        
        
        Test.startTest();
        Opportunity opp = [Select id, AccountId, name,(Select id, name , Spa_Request_Type__c  from quotes)
         from Opportunity where SPA_Resellers__c = 1 and
        id in (select OpportunityId from Quote) limit 1];
        
       
        
        Opportunity_Partner__c op = new Opportunity_Partner__c();
        op.Partner_Account__c = opp.AccountId;
        op.Partner_Type__c = 'Reseller / VAR';
        op.Opportunity__c = opp.Id;
        
        Boolean validationError1 = false;
        Boolean validationError2 = false;
        
        try{
            insert op;
        }catch(Exception e){
			system.debug('there was an error '+e);
            validationError1 = true;
            
        }
         delete op;
         Quote q = new Quote (id = opp.Quotes[0].Id,
                            Spa_Request_Type__c = 'Bid Register Request',
                             Business_Reason_for_Bid_Registration__c = 'blah blah blah test'  ,
                            Scope_of_Bid_Registration__c = 'blah blah blah test', 
                            List_of_Work_Activity_c__c = 'blah blah blah test');
        update q;
        
        try{
            insert op;
        }catch(Exception e){
			system.debug('there was an error '+e);
            validationError2 = true;
            
        } 
        
        Test.stoptest();
        
        system.assertEquals(validationError1, false);
        system.assertEquals(validationError2, true);
    }
    Static testmethod void partnerupdate() {
        test.startTest();
        Opportunity_Partner__c part = [Select Id,Partner_Account__c from 
                                      Opportunity_Partner__c limit 1];
        Account a = [Select id from account limit 1];
        TriggerContextUtility.setFirstRunTrue();
        part.Partner_Account__c = a.Id;
        update part;
        
        
        test.stopTest();
        
    }
    
    Static testmethod void partnerdelete() {
        test.startTest();
        Opportunity_Partner__c part = [Select Id,Partner_Account__c from 
                                      Opportunity_Partner__c where Partner_Type__c = 'Reseller / VAR'  limit 1 ];
        //TriggerContextUtility.setFirstRunTrue();
        delete part;
        
        
        test.stopTest();
        
    }
    

}