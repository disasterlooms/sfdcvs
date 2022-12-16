@isTest
private class TestContactList {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void conlist() {  
        
        Test.startTest();
        
        Account acct = [Select id from Account limit 1];
        String accId = acct.Id;
        
        List <Contact> cons = contactList.getContacts(accId);
        contactList.updateContacts(cons);
        
        Test.stopTest();
        
    }
    
}