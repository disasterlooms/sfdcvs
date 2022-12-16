@isTest
private class TestEvalQuoteReset {
	@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
	 public static testMethod void EvalQuoteReset() {

	 	contact o = [Select Id, UserId__c from Contact where UserId__c = :UserInfo.getUserId() limit 1];
        User u = [SELECT Id, Manager.Contact_ID__c,Contact_ID__c,managerId FROM User WHERE Id= :UserInfo.getUserId() Limit 1] ;
        Account a = [Select Id, Name,Type,billingstate from Account where name ='ZZpbest' limit 1];
        
        Contact con = new Contact(FirstName='Random',LastName='ApexTest', email='apextest3@apexmail.com', phone='9995557865',AccountId=a.id,MailingState='ZZ');
        insert con;
        
        system.debug('user conid '+u.Contact_ID__c);
        Eval_Request__c ev = new Eval_Request__c(
            Expected_Receive_Date__c= date.today(),
            Evaluation_Owner__c = o.Id
            
        ); 
        insert ev; 

	 	PageReference myVfPage = Page.EvalQuoteRequest;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
   
    	ApexPages.currentPage().getParameters().put('id', ev.Id);
    	String id = ApexPages.currentPage().getParameters().get('id');
    	//system.assertEquals(true,id!=null);
   
  
    	ApexPages.StandardController sc = new ApexPages.StandardController(ev);
    	EvalQuoteReset ac = new EvalQuoteReset(sc);
    	ac.reset();


		
	}
	
	
}