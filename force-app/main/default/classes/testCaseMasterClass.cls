@isTest
private class testCaseMasterClass{
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void caseTrigger() {        
        test.startTest();
        Account a = [Select id from account limit 1];
        Contact c = [Select id, email from contact limit 1];
        Case o = new Case();
        o.subject = 'test sub';
        o.description = 'descriptions';
        o.Status = 'New';
        o.Origin = 'Education Portal';
		o.Contact_Email__c = c.Email;
        o.AccountIdText__c = a.Id;
        insert o;
        Case cr = [Select id, accountId,contactid from Case where Contact_Email__c = : o.Contact_Email__c limit 1];
        test.stopTest();
        
        system.debug(cr.AccountId);
        system.debug(cr.ContactId);
        System.assertEquals(cr.AccountId,a.Id);
        System.assertEquals(cr.ContactId,c.Id);
        
        
    }
}