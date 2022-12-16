@isTest
private class TestOpportunityContacts {
@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
       
    static testmethod void getOppContacts()
  {		        
      
      List<Opportunity> opp  = [Select Id from Opportunity limit 2];
      List<OpportunityContactRole> consToMail = new List<OpportunityContactRole>();
      
      //methods getOpp getUser updateopps getSpas
      //setting the variables need to pass to method get spas
      
      String oppid  = opp[0].Id;
     
      //test method for account, contact or opportunity object as record id
      
      test.startTest();      
      consToMail = OppContacts.getOppContacts(oppid);
      OppContacts.sendEmail(consToMail,oppid);      
      
      test.stopTest();
    }
 }