@IsTest
public class testquoteResellerGetProducts  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
     Static testmethod void testGetQuoteStuff(){
         test.startTest();
         Quote q = [Select id,name,(select id from quotelineitems) from Quote limit 1];
         
         //List<QuoteLineItem> qp = new  List<QuoteLineItem>();
         //PageReference myVfPage = Page.accountVBContact;
         //Test.setCurrentPageReference(myVfPage);
         //ApexPages.StandardController sc = new ApexPages.StandardController(eu);
         //ItemEditController ac = new ItemEditController();
         quoteResellerGetProducts ac = new quoteResellerGetProducts();
         ac.accId = q.Id;
         //ac.getPartners();
         ac.getCons();         
         test.stopTest();
         //system.assertEquals(qp[0].Id,q.quotelineitems[0].Id);
     }
    
}