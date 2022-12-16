@IsTest
public class TestPOSOppMatch {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void POSOppMatch(){
        test.starttest();
        PageReference myVfPage = Page.POSSearchMatch;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference
        
        PosOppMatch ac = new PosOppMatch();
        ac.getopps();
        ac.getsales();
        ac.updatesales();
        ac.updateopps();
        test.stopTest();
        
        
    }
    Static testmethod void SpaSearchBidDesk(){
        test.starttest();
         
        
        PageReference myVfPage = Page.SpaOppsSearchBidDeskQuote;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference
         
        
 
        
        SpaSearchBidDesk ac = new SpaSearchBidDesk();
        ac.getspas();       
        CMRProductFind.findProduct();
        
        test.stopTest();
    }
    Static testmethod void cmrclasses(){
        test.starttest();
        
        CMRSalesResellerStateFind.findResellerState();
        CMRStateFind.findState();
        CMRCompanyFind.findAccount();
        CMRAccount.UpdateCmrSales();
        CMRSalesResellerAccountFind.somemethod();
        CMRSalesEUAccountFind.findEUAccount();
        CMRSalesEUStateFind.findEUState();
        UpdateCMRSalesEU myBatchObject = new UpdateCMRSalesEU(); 
        Id batchId = Database.executeBatch(myBatchObject);
        
        UpdateCMRSalesReseller myBatchObject2 = new UpdateCMRSalesReseller(); 
        Id batchId2 = Database.executeBatch(myBatchObject2);
        
        test.stopTest();
        
    }
}