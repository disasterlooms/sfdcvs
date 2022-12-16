@isTest(SeeAllData=true)
public class resellerSpaEmailAlertTest {
	
    @isTest
    public static void testEmail(){
      //  Account a = new Account(name='Neils fun acc', Industry='NeilsIndo', BillingCity='TestCityIndo', BillingCountry='United States', BillingState='California', Website='www.neilstesting.com');
     //   BuildTestData.addRecords();
     //   insert a;
  //      Opportunity o = new Opportunity(name='Test opp', StageName='Open', AccountId=a.id, CloseDate=Date.today());
   //    insert o;
      Opportunity_Partner__c op = new Opportunity_Partner__c(Partner_Account__c=[select id from Account LIMIT 1].id, Opportunity__c=[select id from Opportunity LIMIT 1].id);
       insert op;
        resellerSpaEmailAlert.sendNotification(new List<String>{op.id});
    }
 
}