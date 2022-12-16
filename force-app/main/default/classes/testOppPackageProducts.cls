@isTest
public class testOppPackageProducts {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void OppPackageProducts(){
        
        String recid = '';
        List<Product_Package__c> packages = new List<Product_Package__c>();
        String quant = '2';
        
        
        List<Product2> prods = [Select Id from Product2 limit 3];
        
        test.startTest();
        Opportunity opp = [Select id,pricebook2ID from opportunity limit 1];
        pricebookentry pbe = [Select id,product2.name,product2Id from pricebookentry where isactive = true and pricebook2id = : opp.Pricebook2Id limit 1];
        
        Product_Package__c  pk = new Product_Package__c (name='test apex');
        insert pk;
        
        Package__c  c = new Package__c(Product_Package__c = pk.id,
                                       Product__c   = pbe.product2Id );
        insert c;
        
        packages.add(pk);
        
        recid = opp.id;
        
        OppPackageProducts.addRecords(recid, packages, quant);
        
        OppPackageProducts.addLines(recid, prods, quant);
        
        test.stopTest();
        
        
        
    }
    static testmethod void QuotePackageProducts(){        
        
        List<Product2> prods = [Select Id from Product2 limit 3];
        String recid = '';
        String quant = '2';
        
        test.startTest();
        Opportunity opp = [Select id,pricebook2ID from opportunity limit 1];  
        
        Quote q = new Quote(name= 'test',opportunityid= opp.id);
        insert q;
        recid = q.id;
        OppPackageProducts.addQuoteLines(recid, prods, quant);
        
        test.stopTest();
    }
    
}