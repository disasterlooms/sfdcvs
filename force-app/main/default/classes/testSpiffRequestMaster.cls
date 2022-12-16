@IsTest
public class testSpiffRequestMaster  {
   @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void testMasterTrigger() {
        
        test.startTest();
        //build test data will cover the class currently. This is set up for future testing
        //on the master class
        QuoteLineItem qte = [Select id,Quote.Name,product2Id from QuoteLineItem limit 1]; 
        Account acct  = [Select id, name from account where name ='usditi' limit 1];
        Contact var = [Select id, name from contact limit 1];
        /*
        PricebookEntry pb = [Select product2id from PricebookEntry where isactive = true and Pricebook2Id =: qte.pportunity.Pricebook2Id];
        
        Quotelineitem ql = new Quotelineitem();
        ql.UnitPrice */
        
        Spiff_request__c spiffr = new Spiff_request__c();
        spiffr.Product__c= qte.Product2Id;
        spiffr.Sale_Date__c = date.today();
        spiffr.Quantity__c  = 1;
        spiffr.Requester__c = var.Id;
        spiffr.Spa_Number__c = qte.Quote.Name;
        insert spiffr;
        
        
        Spiff_request__c sTest = [Select id, Spa_Product__c from Spiff_request__c where id =:spiffr.Id];
        test.stopTest();
        
        system.assertEquals(qte.Id , sTest.Spa_Product__c);
        
    }
    
}