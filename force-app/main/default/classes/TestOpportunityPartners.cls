@isTest
private class TestOpportunityPartners {
@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
       
    static testmethod void getOppPartners()
  {		        
      
      List<Opportunity> opp  = [Select Id,(select id from opportunity_partners__r) from Opportunity limit 2];
      List<Opportunity_Partner__c> dpartners = new List<Opportunity_Partner__c>();
      
      //methods getOpp getUser updateopps getSpas
      //setting the variables need to pass to method get spas
      
      String oppid  = opp[0].Id;
      List<Id> oppids = new List<Id>();
      for(Opportunity o : opp){
          for(Opportunity_partner__c op : o.opportunity_partners__r)
              oppids.add(op.id);
      }
      //test method for account, contact or opportunity object as record id
      
      test.startTest();
	  OppResellers.oppResellersget(oppids);      
      dpartners = OpportunityPartners.getOppLInes(oppid);
      OpportunityPartners.updatePartners(dpartners,oppid);
      OpportunityPartners.deleteOppLines(dpartners,oppid);
      
      
      
      test.stopTest();
    }
 }