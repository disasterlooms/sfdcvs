@isTest
private class TestOppPipelineSpas {
@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
static testmethod void getUser()  
  {
       //  Methods industries and status  is metadata, don't need records, 
       //   just need to run the method
       //   product types is querying the product pillar object
       //   which a record is created in build test data testsetup
       test.startTest();
       OppPipelineSpas.getUser();
       test.stopTest();
  }
        
    static testmethod void getSpas()
  {		        
      
      test.startTest();
      //List<Contact>     con  = [Select Id from Contact limit 2];
      //List<Account>     acct = [Select Id from Account limit 2];
      List<Opportunity> opp  = [Select Id from Opportunity limit 2];
      List<Quote> opps  = new List<Quote>();
      
      //methods getOpp getUser updateopps getSpas
      //setting the variables need to pass to method get spas
      
      String recid  = '';
      String ofields = 'Id,AccountId, Opportunity.Name,OpportunityId,'+
                       'ExpirationDate';
      String pfields = 'Quantity,Product2Id,Product2.Name';
      String oppid  = '';
     
      //test method for account, contact or opportunity object as record id
     
      recid= opp[0].Id;
      oppid = opp[0].Id;
      OppPipelineSpas.getSpas(recid,ofields,pfields);
      OppPipelineSpas.getOpp(oppid);
      
     // recid= acct[0].Id;
      //OppPipelineSpas.getSpas(recid,ofields,pfields);
      
     // recid= con[0].Id;
      //opps = OppPipelineSpas.getSpas(recid,ofields,pfields); 
      //opps = [Select id, Resubmission_Notes__c from quote limit 2];
      
      List<Quote> oldspas = new List<Quote>(opps);
      
      List<Quote> newspas = new List<Quote>(opps);
      for(Quote s : newspas){
       s.Resubmission_Notes__c = 'test ww2sda';
          
      }
      
     
      
      OppPipelinUpdateSpas.updateopps(newspas,oldspas);          
      test.stopTest();
    }
 }