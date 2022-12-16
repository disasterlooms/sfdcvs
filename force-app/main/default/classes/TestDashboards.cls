@isTest
private class TestDashboards {
@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }

    static testmethod void getDashboards()
  {		        
      //need to get this implemented
      //will come back and create some dashbaord records and asssert
      //to ensure class works as expected
      test.startTest();      
      String dgroup ='';
      Dashboards.getOppLInes(dgroup);
      test.stopTest();
    }
 }