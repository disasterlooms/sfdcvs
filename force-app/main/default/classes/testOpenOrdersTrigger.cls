@isTest
private class testOpenOrdersTrigger {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    static testmethod void addOpenOrders(){	
         test.startTest();        
        Quote q = [Select id, name,accountid from Quote limit 1];
        VSA_Open_Order__c o = new VSA_Open_Order__c();
        o.Account__c = q.accountId;
        o.PO_Number__c = '1234';
        o.Spa_Number__c = q.name;
        o.Line_ID__c = '423423423';
        insert o;
        
        test.stopTest();
        
    }
}