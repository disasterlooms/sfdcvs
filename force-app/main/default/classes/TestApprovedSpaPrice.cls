@IsTest
public class TestApprovedSpaPrice  {
    Static testmethod void TestApprovedSpaPrice() {


PriceBook2 pb = new Pricebook2(Name='VSA Distributor Price List',IsActive=true);
		insert pb;

		PriceBook2 pb2 = new Pricebook2(Name='VSA Canadian Price List',IsActive=true);
		insert pb2;

		PriceBook2 pb3 = new Pricebook2(Name='VSA CDW Price List',IsActive=true);
		insert pb3;
		
Account acc = new Account(Name = 'Test',billingstate= 'ZZ',BillingCity='City',Type='End User');
insert acc;

Opportunity oppObj = new Opportunity(Name = 'TestOpp',AccountID = acc.Id,Amount = 2000,CloseDate=Date.today(),StageName='Close Won',Type='New Customer',Test_Opportunity__c=True);
//insert oppObj;

Product2 newProd = new Product2(Name = 'test product', family = 'test family');
insert newProd;

PriceBookEntry pbEntry = new PriceBookEntry(
    UnitPrice = 300,
    PriceBook2Id = Test.getStandardPricebookId(),
    Product2Id = newProd.Id,
    IsActive = true);

insert pbEntry ;

OpportunityLineItem oppLine = new OpportunityLineItem(pricebookentryid=pbEntry.Id,Approved_Price__c=2.00,TotalPrice=2000,Quantity = 2,OpportunityID = oppObj.Id);
//insert oppLine;
}
}