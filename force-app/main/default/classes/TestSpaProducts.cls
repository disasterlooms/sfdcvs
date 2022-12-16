@isTest
private class TestSpaProducts {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
  
    static testmethod void getLines()
    {		        
        
        Quote q = [Select id from quote where id in (Select QuoteId from quotelineitem) limit 1];
        
        
        String quoteid= q.Id;
        String wherestmnt= '';
        String addfields= '';
        String orderstmnt= '';
       
        
        
        test.startTest();
        List<QuoteLineItem> lineitems = SpaProducts.getOppLines(quoteid, wherestmnt, addfields, orderstmnt);       
        SpaProducts.updateOppLines(lineitems, quoteid);
        List<QuoteLineItem> dlineitems = lineitems;
        SpaProducts.deleteOppLines(dlineitems, quoteid);
        test.stopTest();
    }
}