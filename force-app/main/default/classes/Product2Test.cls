@isTest
private class Product2Test {

static testmethod void Product2()
  
  {
  Test.startTest();
    Product_Manager__c pillar = new Product_Manager__c(Name='DST');
    insert pillar;
    
    Product2 prod = new Product2(Name='testproduct',Family= pillar.Name);
    insert prod;
    
    
    Test.stopTest();
  }
  }