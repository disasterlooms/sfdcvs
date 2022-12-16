@IsTest
public class TestQuotaCQDays {
     @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void QuotaCQDays() {
        //create the custom settings for test method
        insert new SalesQuarter__c(Days_In_CQ__c = 60,
                                   SetupOwnerId = UserInfo.getOrganizationId());

        PageReference myVfPage = Page.Quotachangedaysinq;
        Test.setCurrentPageReference(myVfPage);
        QuotaCQDays q = new QuotaCQDays();
        q.updatedays();
        q.updatecs();
    }
}