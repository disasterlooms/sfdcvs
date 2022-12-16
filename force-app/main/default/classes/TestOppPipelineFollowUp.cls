@isTest
private class TestOppPipelineFollowUp {
@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
static testmethod void getOppContacts()  
  {
      List<Opportunity> opps = [Select Id from Opportunity limit 5];
      
      test.startTest();      
      
      List<Contact_Role__c> oppcons = OppPipelineFollowUp.getOppContacts(opps);
      OppPipelineFollowUp.emailCons(oppcons);
      test.stopTest();
  }
	
}