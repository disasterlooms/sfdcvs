@IsTest
public class TestSpiffPricing  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void testmasterspiff() {
        test.startTest();
        Pricebookentry pbe = [Select id, product2.name, pricebook2.name from pricebookentry limit 1];
        spiffpricing__c sp = new spiffpricing__c(sku__c = pbe.product2.name, 
                                                 price_book__c = pbe.pricebook2.name,
                                                 Distribution__c = 5);
        insert sp;
        TriggerContextUtility.setFirstRunTrue();
        sp.CDW__c = 4;
        update sp;
        
        
        
        test.stopTest();
        
    }
}