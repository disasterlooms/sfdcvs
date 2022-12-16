@IsTest
public class TestUserOppTeam  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    } 
    
    Static testmethod void communityuser() {
        test.startTest();
        
        list<account> acc = [select name from account where billingcountry = 'United States'];
        
        system.debug(acc.size()+' acct size test');
        
        Contact con = new Contact(LastName = 'Trout',
                                  FirstName='Mike the MVP',
                                  email='troutmvp@testapex.com',
                                  accountid = acc[0].Id,
                                  phone='5625551212',
                                  mailingCountry='United States');
        insert con;
        system.debug(con);
        
        //Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType like '%Partner%' limit 1];
            Profile p = [select Id,name from Profile where UserType like '%Partner%' limit 1];           
            
            User newUser = new User(
                //UserRoleId = ur.Id, 
                profileId = p.id,
                username = 'miketroutmvpusertest@mvptesting.com',
                email = con.email,
                emailencodingkey = 'UTF-8',
                localesidkey = 'en_US',
                languagelocalekey = 'en_US',
                timezonesidkey = 'America/Los_Angeles',
                alias='nuser',
                lastname='lastname',
                contactId = con.id,
                phone=con.phone,
                Country=con.mailingcountry
            );
            insert newUser;  
        }
        
        User u = [Select id,email from user where username = 'miketroutmvpusertest@mvptesting.com' limit 1];
        
        List<Opportunity> opp = [Select id,(select id, status from quotes) from opportunity where id in (select opportunityid from quote) limit 10];
        List<Quote> quoteup = new List<Quote>();
        
        List<Opportunity_Partner__c> parts = new List<Opportunity_Partner__c>();
        for(Opportunity o : opp){
            Opportunity_Partner__c p = new Opportunity_Partner__c(Opportunity__c = o.Id,
                                                                  Partner_Account__c = con.AccountId,
                                                                  Partner_Type__c = 'Distributor'
                                                                 );
            parts.add(p);
            for(Quote q :o.quotes){
                q.status = 'approved';
                quoteup.add(q);
            }
        }
        
        update quoteup;
        
        insert parts;        
        system.debug(u);
        UserOppTeam.communityuser(u.email);
        UserOppTeam.accTrans(u.email);
        UserOppTeam.oppTeam(u.email);
        UserOppTeam.oppTrans(u.email, u.email);
        
        test.stopTest();
        
    }
    Static testmethod void acctrans() {
        test.startTest();
    }
}