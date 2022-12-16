@isTest
public class TestAcctConOwners {
    
    public static testMethod void AcctConOwners() {
        
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
            
            Account a = [Select Id, Name,Type,billingstate,BillingCity from Account where name ='ZZpbest' limit 1];
            
            Contact con = new Contact(FirstName='Random',LastName='ApexTest', email='apextest@apexmail.com', phone='9995557865',AccountId=a.id,MailingState='ZZ');
            insert con;
            
            Contact vscon = [Select Id, OwnerId, UserId__c,Account.Name,
                             Owner.Profile.Name, Owner.LastName 
                             from Contact where Account.Name = 'ViewSonic Corporation' limit 1];
            
            
            
            test.startTest();
            system.debug('viewsonic sales rep for error '+vscon);
            vscon.UserId__c = null;
            update vscon;
            
            PageReference myVfPage = Page.AcctConOwners;
            Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
            
            ApexPages.currentPage().getParameters().put('id',con.id);
            String id = ApexPages.currentPage().getParameters().get('id');
            //system.assertEquals(true,id!=null);
            
            
            ApexPages.StandardController sc = new ApexPages.StandardController(con);
            AcctConOwners ac = new AcctConOwners(sc);
            //PageReference myVfPage = 
            
            ac.updateowners();
            
            a.Type = 'SPG - Tier 1';
            update a;
            
            ac.updateowners();
            
            a.billingstate = null;
            update a;
            
            ac.updateowners();
            
            a.Type = 'End User';
            update a;
            
            
            
            ac.updateowners();
            
            //test for erromessaging if no city
            Account a9 = new Account(Name='Apex Random Error Test',phone='9995557865');
            
            try{
                insert a9;
            }catch(Exception e){
                String t = 'Account State Address Update';
                AdminErrorMessage.SendError(e,t);
                
            }
            
        }
        
        test.stopTest();
        String jsonString = '';
        AccountOwners.UpdateOwners(jsonString);
        
        
        
    }
}