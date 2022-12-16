@isTest
private class testSerialNumberSearch {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    } 
  
    static testmethod void getAssetstest()
    {		        
         test.startTest();
        
        List<Account> a = [Select id,name from account limit 2];
        List<Account> dist = [Select id,name from account where 
                              type = 'Distributor' limit 2];
        product2 prod = [Select id,name from product2 where isactive = true limit 1];
        Contact con = [Select id from Contact limit 1];
        
        Asset ab = new Asset();
        ab.purchasedate = date.today();
        ab.AccountId = a[0].Id;
        ab.Distributor_Account__c = dist[0].Id;
        ab.Reseller_Account__c = a[0].Id;
        ab.Product2Id = prod.Id;
        ab.Name = prod.name;
        insert ab;
        
        Spiff_Request__c s = new Spiff_Request__c();
        s.Sale_Date__c = date.today();
        s.product__c = prod.Id;
        s.Distributor__c = dist[0].Id;
        s.Requester_Company__c = a[0].Id;
        s.End_User__c = a[0].Id;
        s.Quantity__c = 1;
        s.Requester__c = con.Id;
        s.End_User_Email__c = 'johnsmith@nowhere.com';
        s.End_User_Contact_Name__c = 'john';
        s.End_User_Contact_Last_Name__c = 'smith';
        insert s;
        
        String wherestmnt= '';
        String addfields= '';
        String orderstmnt= '';
        String spiffId= '';
        String limitstmt= '';
        String spaId = '';
        Boolean spiffSearch= false;  
        
       
        List <Asset> records = getAssetSearch.getSerialNumber(wherestmnt, addfields, orderstmnt, spiffId, limitstmt, spiffSearch,spaId);
        
        spiffId = s.Id;
        getAssetSearch.getSerialNumber(wherestmnt, addfields, orderstmnt, spiffId, limitstmt, spiffSearch,spaId);
        getAssetSearch.updateSpiffs(wherestmnt, addfields, orderstmnt, spiffId, limitstmt, spiffSearch,records,spaId);
        test.stopTest();
    }
}