@isTest 
public class TestAutoConvertLeads{
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testMethod void createnewlead() {
        User userToCreate = [Select id from user where profile.name='SFDC Admin'  and isactive = true Limit 1];
        
        Test.startTest();    
        Lead leadToCreate =new Lead();
        List<id> Ids= New List<Id>();
        leadToCreate.ownerid= userToCreate.id;
        leadToCreate.LastName ='Gupta';
        leadToCreate.Company='Salesforce';
        leadToCreate.LeadSource='Partner Referral';
        leadToCreate.Email ='johnsmith@outstandingco.comp';  
        leadToCreate.Rating='';
        leadToCreate.Status='';
        insert leadToCreate; 
        
        Account a = [Select id from account where Type = 'End User' and  (NOT Name  like 'viewsonic%') limit 1];
        
        Contact c = new Contact();
        c.accountId = a.id;
        c.email = 'johnsmith@outstandingco.comp';
        c.Lastname = 'Gupta';
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        database.insert(c,dml);
        
        
        Ids.add(leadToCreate.id);
        AutoConvertLeads.LeadAssign(Ids);
        
        Test.stopTest();
    }
}