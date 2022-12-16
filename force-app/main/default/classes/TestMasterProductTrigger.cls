@IsTest
public class TestMasterProductTrigger  {
   @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
 Static testmethod void MasterProductTrigger() {
     //query the test product which is inserted in the test opportunity

      test.startTest();
        Product2 prod = [Select Id,Cost__c from Product2 Where Name ='Apex Test' limit 1];
     //resest context utility, this is only an issue on tests because it is one context. the update happens at once in production.
     //if this is not done on tests, there will not be coverage on updates because updates check context to ensure there is no
     //recursive triggers based on multiple updates, which could occur because there are prcoess builders and workflow actions
     //that can take place after the insert/update
    
     TriggerContextUtility.setFirstRunTrue();
     prod.Cost__c = 300;
     update prod;
     TriggerContextUtility.setFirstRunTrue();
     prod.Cost__c = 400;
     update prod;
     test.stopTest();
    
    
    }
  }