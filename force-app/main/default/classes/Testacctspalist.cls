@isTest 
public class Testacctspalist 
{
 static testMethod void testMethod1() 
 {
 
 BuildTestData.AddRecords();

        Account testAccount = [Select Id from Account where name ='ZZpbest' limit 1];

 Test.StartTest(); 
  ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
  acctspalist testRelatedSpas = new acctspalist(sc);

  PageReference pageRef = Page.RelatedSpas; 
  pageRef.getParameters().put('id', String.valueOf(testAccount.Id));
  Test.setCurrentPage(pageRef);
 Test.StopTest();
 }
}