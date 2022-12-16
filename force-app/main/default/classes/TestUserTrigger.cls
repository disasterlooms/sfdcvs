@IsTest
public class TestUserTrigger { 
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void UserTriggerTest() {
        test.startTest();
        
        List<Contact> cons = [Select id , firstname, lastname, email, Account.BillingPostalCode, account.phone,phone,account.billingstreet,account.billingCity,account.billingState,account.billingcountry
                              from contact where Account.Type = 'VAR' Limit 1];
        
        
        List <User> newUsers = new List<User>();
        String ph = '';
        String langLocale = '';
        Integer lastn = 6;
        for(Contact c : cons){
            if(c.phone == null){
                ph = c.account.phone;
            }else{
                ph = c.phone;
            }
            if(c.lastname.length() <6){
              lastn = c.lastname.length();  
            }
            if(c.firstname == null){
             c.firstname = 'FirstName';
            }
            system.debug('last name  '+c.lastname+' '+ lastn);
            User u = new User();
            u.phone = ph;
            u.firstName = c.FirstName;
            u.lastName = c.LastName;
            u.ContactId = c.Id;
            u.Username = 'username';
            u.Email = c.email;
            u.CommunityNickname = c.firstname.left(1)+c.lastname.left(lastn);
            u.Alias = c.lastname.left(3)+c.firstname.left(1);
            u.TimeZoneSidKey = 'America/Phoenix'; // Required
            u.LocaleSidKey = 'en_US'; // Required
            u.EmailEncodingKey = 'ISO-8859-1'; // Required
            u.LanguageLocaleKey = 'en_US'; // Required
            u.ProfileId = '00e1H000001FqFf';
            u.isActive = true;
            u.street = c.Account.BillingStreet;
            u.city = c.Account.BillingCity;
            u.State = c.Account.BillingState;
            u.Country = c.Account.BillingCountry;
            u.postalcode = c.Account.BillingPostalCode;
            u.External_partner__c = true;
            u.username = c.email;
            newUsers.add(u);
            
        }
        
        insert newUsers;
        
        User us = [Select id, email from User where id in:newUsers limit 1];
        us.email  = 'anewemail@mailtestingdasf.com';
        TriggerContextUtility.setFirstRunTrue();
        update us;
        
        
        test.stopTest();
        
    }
}


/*
@isTest
public class TestUserTrigger {
@testSetup
private static void BuildTestData(){
BuildTestData.AddRecords();
}
static void UserTriggerTest() {      


FutureContext.setFutureRanFalse();

User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
System.runAs ( thisUser ) {

UserRole r = new UserRole(DeveloperName = 'MyCustomRoleUserSalescontact', Name = 'My Role Contact');
insert r;

User u = new User(
ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales - RBM'].Id,
LastName = 'last testingapex',
Email = 'puser0003@amamama2.com',
Username = 'puser0003@amamama2.com' + System.currentTimeMillis(),
CompanyName = 'TEST Apex',
Title = 'title',
Country = 'United States',
Phone = '5625551212',
Alias = 'alias',
TimeZoneSidKey = 'America/Los_Angeles',
EmailEncodingKey = 'UTF-8',
LanguageLocaleKey = 'en_US',
LocaleSidKey = 'en_US',
UserRoleId = r.Id,
IsActive = true,
Sales_Category__c = 'TM'
);


Account vs = new Account (Name ='ViewSonic Corporation',
BillingState = 'ZZ',
Industry='Education',
website = 'ww.hasiefa.comid',
BillingStreet = '10 Point Dr',
BillingCity ='Brea', 
BillingPostalCode ='93546', 
Type = 'End User',
Apex_Test__c = true);

insert vs;
insert u;
}

test.startTest();

List<Contact> cons = [Select id , firstname, lastname, email, Account.BillingPostalCode, account.phone,phone,account.billingstreet,account.billingCity,account.billingState,account.billingcountry
from contact where Account.Type = 'VAR' Limit 1];


List <User> newUsers = new List<User>();
String ph = '';
String langLocale = '';
for(Contact c : cons){
if(c.phone == null){
ph = c.account.phone;
}else{
ph = c.phone;
}

User u = new User();
u.phone = ph;
u.firstName = c.FirstName;
u.lastName = c.LastName;
u.ContactId = c.Id;
u.Username = 'username';
u.Email = c.email;
u.CommunityNickname = c.firstname.left(1)+c.lastname.left(6);
u.Alias = c.lastname.left(3)+c.firstname.left(1);
u.TimeZoneSidKey = 'America/Phoenix'; // Required
u.LocaleSidKey = 'en_US'; // Required
u.EmailEncodingKey = 'ISO-8859-1'; // Required
u.LanguageLocaleKey = 'en_US'; // Required
u.ProfileId = '00e1H000001FqFf';
u.isActive = true;
u.street = c.Account.BillingStreet;
u.city = c.Account.BillingCity;
u.State = c.Account.BillingState;
u.Country = c.Account.BillingCountry;
u.postalcode = c.Account.BillingPostalCode;
u.External_partner__c = true;
u.username = c.email;
newUsers.add(u);

}

insert newUsers;

User us = [Select id, email from User where id in:newUsers limit 1];
us.email  = 'anewemail@mailtestingdasf.com';
update us;


test.stopTest();



}


}
*/