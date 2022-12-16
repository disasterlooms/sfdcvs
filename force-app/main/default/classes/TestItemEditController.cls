@isTest
public class TestItemEditController {

Static testmethod void TestItemEditController () {

    {

Test.startTest();

    // set the test's page to your VF page
     
     BuildTestData.AddRecords();

     User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            System.runAs ( thisUser ) {
            
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole2', Name = 'My Role2');
            insert r;
            
        User u = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'SFDC Admin'].Id,
             LastName = 'last testingapex',
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST Apex',
             Title = 'title',
             Country = 'United States',
             Phone = '5625551212',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
             UserRoleId = r.Id
        ); 
        
       insert u;
       
       Account a = [Select Id, Name,Type,billingstate from Account where name ='ZZpbest' limit 1];
       
        Contact con = new Contact(FirstName='Random',LastName='ApexTest', email='apextest@apexmail.com', phone='9995557865',AccountId=a.id,MailingState='ZZ');
        insert con;
       
       Eval_Request__c ev = new Eval_Request__c(
       Expected_Receive_Date__c= date.today(),
       Evaluation_Owner__c = con.id
             
        ); 
        insert ev; 


        Eval_Unit_Details__c eu = new Eval_Unit_Details__c(
			Eval_Request__c = ev.Id,
			SKU__c = [Select Id from Product2 where Name ='Apex Test'].id,
			RMA__c = '12345'
			);

       PageReference myVfPage = Page.EvalRequestsSearch;
       Test.setCurrentPageReference(myVfPage);
       String id = ApexPages.currentPage().getParameters().get('id');
       //ApexPages.StandardController sc = new ApexPages.StandardController(eu);
       //ItemEditController ac = new ItemEditController();
       ItemEditController ac = new ItemEditController(new ApexPages.StandardController(eu));

       ac.search();
       ac.cancel();
       ac.save();



    }      
      

     Test.stopTest();
}
}
}