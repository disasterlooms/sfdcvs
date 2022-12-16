@isTest
private class EvalUnitsTest {
@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
static testmethod void EvalUnits()
  
  {
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
       
        Contact con = new Contact(FirstName='Random',LastName='ApexTest', email='apextest@apexmail.com', phone='9995557865',AccountId=a.id,
                                  MailingCountryCode = 'US',MailingStateCode='CA');
                try{
                     insert con;
                }catch(Exception e){
                    con = [Select id from Contact where email = 'apextest@apexmail.com' limit 1];
                }
               
       
       Eval_Request__c ev = new Eval_Request__c(
       Expected_Receive_Date__c= date.today(),
       Evaluation_Owner__c = con.id
             
        ); 
        insert ev; 
        
        
        
        

        
        PageReference myVfPage = Page.EvalDetails;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
   
        ApexPages.currentPage().getParameters().put('CF00NA000000AKSaY_lkid',ev.id);
        String id = ApexPages.currentPage().getParameters().get('id');
        //system.assertEquals(true,id!=null);
   
  
        ApexPages.StandardController sc = new ApexPages.StandardController(ev);
        EvalUnits ac = new EvalUnits();
        
        ac.addRows();
        
        ac.delWrapper();
        
        
        
        ac.save();
      
                                                    



  
    // set the test's page to your VF page
     //Test.setCurrentPage(Page.EvalDetails);
     //PageReference pageRef = Page.EvalDetails; 
     //Eval_Unit_Details__c pu = new Eval_Unit_Details__c();
     
     //ApexPages.StandardController controller = new ApexPages.StandardController(pu);
    
      // stop the test
    //Test.stopTest();
    
    }
  }
  }