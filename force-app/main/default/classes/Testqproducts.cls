@IsTest
public class Testqproducts {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void qproducts(){
        
        Quote q = new Quote(OpportunityId = [Select id from opportunity limit 1].id,name='apex test');
        insert q;
        
        PageReference myVfPage = Page.QuoteProductsInactive;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference
        
        System.currentPageReference().getParameters().put('id', q.Id);
        
        qproducts ac = new qproducts(new ApexPages.StandardController(q));
        
        //qproducts ac = new qproducts();
        ac.getprods();
        ac.uphighprods();
        ac.upInactive();
    }
}