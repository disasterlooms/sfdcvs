@isTest
public class TestMasterEmailMessage {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void QuoteEmail() {
        test.startTest();
        Quote q = [Select id,Resubmitter__c  from quote limit 1];
        q.Resubmitter__c = UserInfo.getUserId();
        update q;
       
        
        EmailMessage e = new EmailMessage(subject = 'Need Info for SPA',
                                          ToAddress  = UserInfo.getUserEmail(),
                                          RelatedToId = q.Id);
        
        
        insert e;
        test.stopTest();
        
    }
    
}