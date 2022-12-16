@isTest
public class testMasterBundleProductsTrigger {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void getRecords(){
        Product_Package__c  pk = new Product_Package__c (name='test apex');
        insert pk;
        
        List<Product2> prods = [Select id from product2 where isactive = true limit 2];
        
        Package__c  c = new Package__c(Product_Package__c = pk.id,
                               Product__c   = prods[0].Id );   
        
        test.startTest();
        insert c;
        TriggerContextUtility.setFirstRunTrue();
        c.Product__c = prods[1].Id;
        update c;
        TriggerContextUtility.setFirstRunTrue();
        delete c;       
        
        test.stopTest();
        
        
        
    }    

}