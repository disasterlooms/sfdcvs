@IsTest
public class TestMasterAccessoriesTrigger  {
   @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void insertAcc() {
       List<Product2> prods = [Select id from Product2 where isactive= true limit 3];
        
        List<Accessories__c> newacc = new List<Accessories__c>();
        for(Product2 p : prods){
           Accessories__c acc = new Accessories__c(Main_Product__c = p.id, Accessory_Product__c = p.id);
            newacc.add(acc);
        }
        test.startTest();
        insert newacc;
        
        delete newacc[0];
        test.stopTest();
        
       
        
        
    }

}