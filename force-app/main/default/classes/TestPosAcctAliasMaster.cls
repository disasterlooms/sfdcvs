@IsTest
public class TestPosAcctAliasMaster  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void MasterAcctAliasInsert() {
        test.startTest();
        List<Account> accts = [Select id,name from account limit 2];
        
        POSAccountAliases__c p = new POSAccountAliases__c();
        p.name = 'Test Name';
        p.SFDC_Account__c = null;
        
        insert p;
        
        POSAccountAliases__c p2 = new POSAccountAliases__c();
        p2.name = 'Test Name';
        p2.SFDC_Account__c = accts[0].Id;
        
        insert p2;
        
        p.SFDC_Account__c = accts[1].Id;
        update p;
        
    }

}