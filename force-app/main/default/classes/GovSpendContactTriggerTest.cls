@isTest
public class GovSpendContactTriggerTest {

    @isTest
    static void test_Success(){
        Campaign cam = new Campaign(name=System.Label.GovSpend_Campaign_Name);
        insert cam;
    	Staging_GovSpend_Contact_Header__c sgch = new Staging_GovSpend_Contact_Header__c();
        insert sgch;
        Staging_GovSpend_Contact__c sgc = new Staging_GovSpend_Contact__c(Staging_GovSpend_Contact_Header__c=sgch.id, FirstName__c='John', LastName__c='Doe', Contact_ID__c='abc123', Email__c='johndoe@yahoo.com', Account_Name__c='Walmart');
        insert sgc;
        System.assertEquals(1, [select id from Lead where Email='johndoe@yahoo.com'].size());
     //   Contact c = new Contact(FirstName='Jane', LastName='Doe', Email='jdoe@gmail.com', AccountId=[select id from account limit 1].id);
   //     insert c;
     //   Staging_GovSpend_Contact__c sgc2 = new Staging_GovSpend_Contact__c(Staging_GovSpend_Contact_Header__c=sgch.id, FirstName__c='Jane', LastName__c='Doe', Contact_ID__c='abc124', Email__c='jdoe@gmail.com', Account_Name__c='Walmart');
     //   insert sgc2;
        Staging_GovSpend_Contact__c sgc3 = new Staging_GovSpend_Contact__c(Staging_GovSpend_Contact_Header__c=sgch.id, FirstName__c='John', LastName__c='Doe', Contact_ID__c='abc123', Email__c='johndoe@yahoo.com', Account_Name__c='Walmart');
        insert sgc3;
        System.assertEquals(1, [select id from Lead where Email='johndoe@yahoo.com'].size()); //we know a contact was updated and a Lead was updated. No lead creation.
    }
    
}