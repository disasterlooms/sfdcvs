@isTest
private class TestProdAccExtension {
	static testmethod void ProdAccExtension()  
  { 
    BuildTestData.AddRecords();
    
    Product2 p = [Select Id from Product2 where name ='Apex Test' limit 1];
    
    PageReference myVfPage = Page.Accessories;
    Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
   
    ApexPages.currentPage().getParameters().put('id',p.id);
    String id = ApexPages.currentPage().getParameters().get('id');
    ApexPages.StandardController sc = new ApexPages.StandardController(p);
    ProdAccExtension mc  = new ProdAccExtension(sc);
      mc.getaccs();
      mc.updateaccs();
      
  }    
    
}