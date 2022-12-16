public with sharing class ProductService
{
    public static void findProductManager(List<Product2> records)
    {
        Set<String> families = new Set<String>();
        for (Product2 record : records) families.add(record.Family);

        Map<String, Product_Manager__c> managers = new Map<String, Product_Manager__c>();
        for (Product_Manager__c manager : [
            SELECT Name FROM Product_Manager__c
            WHERE Name IN :families
        ]) managers.put(manager.Name, manager);

        for (Product2 record : records)
            if (managers.containsKey(record.Family))
             if(record.Product_Line__c == null){
                record.Product_Line__c = managers.get(record.Family).Id;
            }
    }
}