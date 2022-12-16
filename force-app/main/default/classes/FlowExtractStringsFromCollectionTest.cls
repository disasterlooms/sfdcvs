@IsTest
public class FlowExtractStringsFromCollectionTest {
    @TestSetup
    static void setup(){
        List<Account> accounts = new List<Account>();
        for(Integer i = 1; i <= 10; i++) {
            Account account = new Account(
                Name = 'Test Account ' + i,
                Industry= 'Business',
                website = 'business.com',
                Type = 'End User',
            
                BillingCountry ='United States', 
                BillingStreet = 'test1',
                BillingCity ='test1',
                BillingState ='Alabama',
                BillingPostalCode ='93546'
            );
            accounts.add(account);
        }
        accounts.add(new Account(Name='Test Account 1', Industry= 'Business',
                website = 'business.com',
                Type = 'End User',
            
                BillingCountry ='United States', 
                BillingStreet = 'test1',
                BillingCity ='test1',
                BillingState ='Alabama',
                BillingPostalCode ='93546'  ));
        insert accounts;
    }

    @IsTest
    static void emptyInputCollectionThrowsError() {
        List<FlowExtractStringsFromCollection.Request> flowRequests = new List<FlowExtractStringsFromCollection.Request>();
        FlowExtractStringsFromCollection.Request flowRequest = new FlowExtractStringsFromCollection.Request();
        flowRequest.inputRecordCollection = new List<Account>();
        flowRequest.fieldAPIName = '';
        flowRequests.add(flowRequest);
        FlowExtractStringsFromCollection.ExtractStringsException exc;
        Test.startTest();
        try {
           List<FlowExtractStringsFromCollection.Result> results = FlowExtractStringsFromCollection.extract(flowRequests);
        } catch (FlowExtractStringsFromCollection.ExtractStringsException e) {
            exc = e;
        }
        Test.stopTest();
        System.assert(exc != null, 'DedupeFieldsFromCollectionTest : emptyInputCollectionReturnsEmptyOutputCollection failed');
    }
    
    @IsTest
    static void extractTextCollectionNoDedupe() {
        List<FlowExtractStringsFromCollection.Request> flowRequests = new List<FlowExtractStringsFromCollection.Request>();
        FlowExtractStringsFromCollection.Request flowRequest = new FlowExtractStringsFromCollection.Request();
        flowRequest.inputRecordCollection = [SELECT Name FROM Account LIMIT 50];
        flowRequest.fieldAPIName = 'name';
        flowRequest.dedupeValues = false;
        flowRequests.add(flowRequest);
        Test.startTest();
        List<FlowExtractStringsFromCollection.Result> results = FlowExtractStringsFromCollection.extract(flowRequests);
        Test.stopTest();
        System.assert(results[0].fieldValueCollection.size() == 11, 'DedupeFieldsFromCollectionTest : dedupeTextCollectionSuccess failed');
    }

    @IsTest
    static void extractTextCollectionSuccess() {
        List<FlowExtractStringsFromCollection.Request> flowRequests = new List<FlowExtractStringsFromCollection.Request>();
        FlowExtractStringsFromCollection.Request flowRequest = new FlowExtractStringsFromCollection.Request();
        flowRequest.inputRecordCollection = [SELECT Name FROM Account LIMIT 50];
        flowRequest.fieldAPIName = 'name';
        flowRequests.add(flowRequest);
        Test.startTest();
        List<FlowExtractStringsFromCollection.Result> results = FlowExtractStringsFromCollection.extract(flowRequests);
        Test.stopTest();
        System.assert(results[0].fieldValueCollection.size() == 10, 'DedupeFieldsFromCollectionTest : dedupeTextCollectionSuccess failed');
    }
    /*
    @IsTest
    static void extractTextCollectionSuccessNullValues() {
        List<Account> accounts = [Select Id, BillingCity from Account LIMIT 8]; // out of 10: leave one null, set one unique
        for (Account act: accounts) {
            act.BillingCity = 'Test City';
        }
        update accounts;
        List<Account> accounts2 = [Select Id, BillingCity from Account WHERE BillingCity != 'Test City' LIMIT 1]; // out of 10: leave one null, set one unique
		accounts2[0].BillingCity = 'Test City 2';
        update accounts2;
        
        List<FlowExtractStringsFromCollection.Request> flowRequests = new List<FlowExtractStringsFromCollection.Request>();
        FlowExtractStringsFromCollection.Request flowRequest = new FlowExtractStringsFromCollection.Request();
        flowRequest.inputRecordCollection = [SELECT BillingCity FROM Account LIMIT 50];
        flowRequest.fieldAPIName = 'BillingCity';
        flowRequests.add(flowRequest);
        Test.startTest();
        List<FlowExtractStringsFromCollection.Result> results = FlowExtractStringsFromCollection.extract(flowRequests);
        Test.stopTest();
        System.assert(results[0].fieldValueCollection.size() == 2, 'DedupeFieldsFromCollectionTest : dedupeTextCollectionSuccess failed');
    }
    */

}