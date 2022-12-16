@isTest
public class TestCompMultiSelect {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void getRecords(){
        String wherestmt = 'where Name != null';
        String limitstmt = 'limit 5';
        String orderstmnt = '';
        String obj = 'Product_Package__c';
        String addfields = '';
        String parentid = '';
        String searchtxt = '';
        String topbutton = 'false';
        Product_Package__c  pk = new Product_Package__c (name='test apex');
        insert pk;
        
        Product2 p = [Select id from product2 where isactive = true limit 1];
        
        List<SObject> children = new List<SObject>();
        String objToCreate = 'Package__c';
        List<String>  objToCreateFields = new List<String>();
        objToCreateFields.add('Product_Package__c');
        objToCreateFields.add('Product__c');
        //objToCreateFields.add('Product__c');
        
        Package__c  c = new Package__c(Product_Package__c = pk.id,
                               Product__c   = p.Id );
        children.add(c);
        
        parentId = pk.Id;
        
        
        test.startTest();
        CompMultiSelect.getRecords(wherestmt, limitstmt, orderstmnt, obj, searchtxt, addfields, parentid, topbutton);
        CompMultiSelect.createChildren(children, parentId, objToCreate, objToCreateFields);
        
        test.stopTest();
        
        
        
    }    

}