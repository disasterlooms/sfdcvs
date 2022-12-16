@isTest
public class DedupeRecordCollectionTest {
    
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
        //accounts.add(new Account(Name='Test Account 1'));
        insert accounts;
    }
    
    @isTest
    public static void CanGetRecordsFromIds() {
        

        DedupeRecordCollection.FlowRequest curRequest = new DedupeRecordCollection.FlowRequest();
        curRequest.fieldToDedupeOn = 'Id';
        curRequest.inputRecordCollection = [SELECT Id FROM Account LIMIT 50];
        //curRequest.fieldNames = 'Id,Name';
        //curRequest.inputIds = new List<String>();
        //curRequest.inputIds.add('4o4M4o4M');
        //curRequest.inputIds.add('j34k4o4M');
        
        List<DedupeRecordCollection.FlowRequest> curRequests = new List<DedupeRecordCollection.FlowRequest>();
        curRequests.add(curRequest);
        List<DedupeRecordCollection.FlowResponse> curResponses = DedupeRecordCollection.dedupe(curRequests);
        //System.debug('curResponses is:' + curResponses);
        //System.assertEquals(curResponses[0].records, null);
    }

}