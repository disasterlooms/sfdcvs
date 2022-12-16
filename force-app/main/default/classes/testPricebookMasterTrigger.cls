@IsTest
public class testPricebookMasterTrigger  {
   @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
 Static testmethod void MasterProductTrigger() {
     //query the test product which is inserted in the test opportunity
 
     test.startTest();
     List<PriceBook2> pricebooks = new List<PriceBook2>();
     
     PriceBook2 pb = new Pricebook2(Name='VSA Distributor Price List',IsActive=true,currencyIsoCode__c = null);
     pricebooks.add(pb);
     
     PriceBook2 pb2 = new Pricebook2(Name='VSA Canadian Price List',IsActive=true,currencyIsoCode__c = 'XYZforceErrr');
     pricebooks.add(pb2);
     
     try{
         insert pricebooks;
     }catch(Exception e){
         
     }
     
     
     
     test.stopTest();
    
    
    }
  }