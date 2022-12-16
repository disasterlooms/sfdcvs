@IsTest
public class FlowFindCommonAndUniqueRecordsTest {
    @TestSetup
    static void setup(){
        List<Account> accounts = new List<Account>();
        
        Account account1 = new Account(
            Name = 'Test Account 1',
            Industry= 'Business',
            website = 'business.com',
            Type = 'End User',
            
            BillingCountry ='United States', 
            BillingStreet = 'test1',
            BillingCity ='test1',
            BillingState ='Alabama',
            BillingPostalCode ='93546'    
        );
        accounts.add(account1);

        Account account2 = new Account(
            Name = 'Test Account 2',
            Industry= 'Business',
            website = 'business2.com',
            Type = 'End User',
            
            BillingCountry ='United States', 
            BillingStreet = 'test2',
            BillingCity ='test2',
            BillingState ='Alabama',
            BillingPostalCode ='93546' 
        );
        accounts.add(account2);        
        
        Account account3 = new Account(
            Name = 'Test Account 3',
            Industry= 'Business',
            website = 'business3.com',
            Type = 'End User',
            
            BillingCountry ='United States', 
            BillingStreet = 'test3',
            BillingCity ='test3',
            BillingState ='Alabama',
            BillingPostalCode ='93546'
        );
        accounts.add(account3);        
        insert accounts;
        
    	List<Contact> contacts = new List<Contact>();
        
        Contact contact1 = new Contact(
        FirstName = 'Test',
        LastName = 'Contact',
        Email = 'testcontact@testytest.com',
        AccountId = account1.Id);  
        contacts.add(contact1);

        Contact contact2 = new Contact(
        FirstName = 'Test',
        LastName = 'Contact2',
        Email = 'testcontact2@testytest.com',
        AccountId = account1.Id);  
        contacts.add(contact2);
        
        Contact contact3 = new Contact(
        FirstName = 'Test', 
        LastName = 'Contact3',
        Email = 'testcontact3@testytest.com',
        AccountId = account2.Id);  
        contacts.add(contact3);
        
        insert contacts;
    }
    
    @IsTest
    static void testCompareRecords() {
        List<Account> accountsInSource = [Select Id from Account];
        List<Contact> contactsInTarget = [Select Id,AccountId from Contact];
        
        List<FlowFindCommonAndUniqueRecords.Request> flowRequests = new List<FlowFindCommonAndUniqueRecords.Request>();
        FlowFindCommonAndUniqueRecords.Request flowRequest = new FlowFindCommonAndUniqueRecords.Request();
        flowRequest.sourceRecordCollection = accountsInSource;
        flowRequest.targetRecordCollection = contactsInTarget;
        flowRequest.sourceUniqueID = 'Id';
        flowRequest.targetUniqueID = 'AccountId';
        flowRequests.add(flowRequest);
        Test.startTest();
        List<FlowFindCommonAndUniqueRecords.Result> results = FlowFindCommonAndUniqueRecords.compareRecords(flowRequests);
        Test.stopTest();
        System.assertEquals(1, results[0].sourceUniqueRecordCollection.size(), 'sourceUnique failed');
        System.assertEquals(2, results[0].sourceCommonRecordCollection.size(), 'sourceCommon failed');
    }
    
    @IsTest
    static void testEmptyCollection() {
        List<Account> accountsInSource = [Select Id from Account];
        List<Contact> contactsInTarget = [Select Id,AccountId,Name from Contact WHERE FirstName = 'Darth'];
        
        List<FlowFindCommonAndUniqueRecords.Request> flowRequests = new List<FlowFindCommonAndUniqueRecords.Request>();
        FlowFindCommonAndUniqueRecords.Request flowRequest = new FlowFindCommonAndUniqueRecords.Request();
        flowRequest.sourceRecordCollection = accountsInSource;
        flowRequest.targetRecordCollection = contactsInTarget;
        flowRequest.sourceUniqueID = 'Id';
        flowRequest.targetUniqueID = 'AccountId';
        flowRequests.add(flowRequest);
        Test.startTest();
        List<FlowFindCommonAndUniqueRecords.Result> results = FlowFindCommonAndUniqueRecords.compareRecords(flowRequests);
        Test.stopTest();
        System.assertEquals(3, results[0].sourceUniqueRecordCollection.size(), 'sourceUnique failed');
        System.assertEquals(0, results[0].sourceCommonRecordCollection.size(), 'sourceCommon failed');
    }
    
    // Test created to specifically check against records that do not currently have record ids
    // Target Unique can then be inserted by admins to avoid errors
    // See github issue 1067
    @IsTest
    static void testUserWithoutPermissionSetAssignments() {
        List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
        
        User u = new User();
        u.FirstName = 'Fry';
        u.LastName = 'McAllistor';
        u.Alias = '12345F';
        u.Email = 'frymcallistor@testingflows.com.fake';
        u.Username = 'frymcallistor@testingflows.com.fake';
        u.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'][0].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.LanguageLocaleKey = 'en_US';
        insert u;
        
        PermissionSet p1 = new PermissionSet();
        p1.Name = 'Testing_Has_Permission_Set';
        p1.Label = 'Testing Has Permission Set';
        
        PermissionSet p2 = new PermissionSet();
        p2.Name = 'Testing_Does_Not_Have_Permission_Set';
        p2.Label = 'Testing Does Not Have Permission Set';
        insert new List<PermissionSet>{p1, p2};
        
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        psa1.PermissionSetId = p1.Id;
        psa1.AssigneeId = u.Id;
        insert psa1;
        psaList.add(psa1);

		PermissionSetAssignment psa2 = new PermissionSetAssignment();
        psa2.PermissionSetId = p2.Id;
        psa2.AssigneeId = u.Id;
        psaList.add(psa2);
        
        List<FlowFindCommonAndUniqueRecords.Request> flowRequests = new List<FlowFindCommonAndUniqueRecords.Request>();
        FlowFindCommonAndUniqueRecords.Request flowRequest = new FlowFindCommonAndUniqueRecords.Request();
        flowRequest.sourceRecordCollection = [SELECT Id, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :u.Id];
        flowRequest.targetRecordCollection = psaList;
        flowRequest.sourceUniqueID = 'PermissionSetId';
        flowRequest.targetUniqueID = 'PermissionSetId';
        flowRequests.add(flowRequest);
        Test.startTest();
        List<FlowFindCommonAndUniqueRecords.Result> results = FlowFindCommonAndUniqueRecords.compareRecords(flowRequests);
        Test.stopTest();
        System.assertEquals(1, results[0].targetUniqueRecordCollection.size(), 'targetUnique failed');
        System.assertEquals(1, results[0].targetCommonRecordCollection.size(), 'targetCommon failed');
    }

}