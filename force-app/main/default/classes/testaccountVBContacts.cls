@IsTest
public class testaccountVBContacts  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
     Static testmethod void MasterEvalUnitsTrigger(){
         test.startTest();
         Account a = [Select id from account limit 1];   
         
         PageReference myVfPage = Page.accountVBContact;
         Test.setCurrentPageReference(myVfPage);
         //ApexPages.StandardController sc = new ApexPages.StandardController(eu);
         //ItemEditController ac = new ItemEditController();
         accountVBContact ac = new accountVBContact();
         ac.accId = a.Id;
         ac.getCons();         
         test.stopTest();  
     }
    
}