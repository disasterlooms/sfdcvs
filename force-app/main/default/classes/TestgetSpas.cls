@isTest
private class TestgetSpas {
@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
       
    static testmethod void TestgetSpas()
  {		        
      
      List<Quote> quotes  = [Select Id from Quote limit 2];
      
      //methods getOpp getUser updateopps getSpas
      //setting the variables need to pass to method get spas
      
      String quoteid  = quotes[0].Id;
     
      //test method for account, contact or opportunity object as record id
      
      test.startTest();
      getSpas.getspas(quoteid);
      
      
      test.stopTest();
    }
 }