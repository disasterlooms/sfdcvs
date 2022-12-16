@isTest
private class TestSpaSearch {
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
       SpaSearch.getUser();
       SpaSearch.getStatus();
       SpaSearch.getProdTypes();
       SpaSearch.getIndustries();
       test.stopTest();
  }
        
    static testmethod void getSpas()
  {		        
           
      List<Opportunity> opps = new List<Opportunity> ();
      
      String product  = '';
      String reseller = '';
      String enduser  = '';
      String industry = '';
      String spaid = '';
      String family = '';
      //methods getOpp getUser updateopps getSpas
      //setting the variables need to pass to method get spas
      String ofields = 'Id,AccountId, Account.Name,Product_Name_Main__c,'+
                       'CloseDate,Project_or_Site_Information__c,name,Resellers_and_Type__c,'+
                       'Pricebook2Id';
      String pfields = 'Name,Quantity,Product2Id,Product2.Name,ServiceDate'+
                       ',Ship_Out_Date__c,status__c';
     
      //test method for account, contact or opportunity object as record id
      
      test.startTest();
      
      opps = SpaSearch.getSpas(product,reseller,enduser,industry,ofields,pfields,family,spaid);
      
      product  = 'va';
      reseller = 'edu';
      enduser  = 'edu';
      industry = 'edu';
      spaid = '';
      family = 'monitor';
      
      SpaSearch.getSpas(product,reseller,enduser,industry,ofields,pfields,family,spaid);
      
      SpaSearch.updateopps(opps,product);
      
      test.stopTest();
    }
 }