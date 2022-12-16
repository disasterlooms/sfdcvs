@isTest
public class testSpaSearchBid {
     @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }

    public static testMethod void testMyController() {
                
        PageReference pageRef = Page.SpaOppsSearchBidDeskQuote ;
        Test.setCurrentPage(pageRef);
      
        SpaSearchBidDesk cont = new SpaSearchBidDesk();
        
        pageRef.getParameters().put('prodsearch', ' ');
        pageRef.getParameters().put('enduser', ' ');
        pageRef.getParameters().put('res', ' ');
        pageRef.getParameters().put('state', ' ');
        pageRef.getParameters().put('territory', ' ');
        pageRef.getParameters().put('city', ' ');
        pageRef.getParameters().put('owner', ' ');
        pageRef.getParameters().put('spa', ' ');
        pageRef.getParameters().put('industry', ' ');
        pageRef.getParameters().put('prodtype', ' ');
        cont.getspas();
        
        

        
    }
}