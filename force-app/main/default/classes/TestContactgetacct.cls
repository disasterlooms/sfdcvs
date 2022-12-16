@IsTest
public class TestContactgetacct {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
	 Static testmethod void TestContactgetacct () {
         /*
         Test.startTest();
    	 // set the test's page to your VF page
         Test.setCurrentPage(Page.ContactNewOverride);
         
         Account acc = [Select Id from Account where name = 'ZZpbest' limit 1];
         
         //PageReference myVfPage = Page.ContactNewOverride;
         //Test.setCurrentPageReference(myVfPage);
         
         System.currentPageReference().getParameters().put('accid', acc.Id);
         
         Contactgetacct  controller = new Contactgetacct(new ApexPages.StandardController(new Contact ()));
         
         Test.stopTest();
         */
     }
}