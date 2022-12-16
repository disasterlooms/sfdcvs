@IsTest
public class TestTeamMemberCount  {
     @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void TestTeamMemberCount() {

		PriceBook2 pb = new Pricebook2(Name='VSA Distributor Price List',IsActive=true);
		insert pb;

		PriceBook2 pb2 = new Pricebook2(Name='VSA Canadian Price List',IsActive=true);
		insert pb2;

		PriceBook2 pb3 = new Pricebook2(Name='VSA CDW Price List',IsActive=true);
		insert pb3;

        Account acc = [Select Id from Account where name ='ZZpbest' limit 1];


Opportunity oppObj = new Opportunity(Name = 'TestOpp',AccountID = acc.Id,Amount = 2000,CloseDate=Date.today(),StageName='Close Won',Type='New Customer',Test_Opportunity__c=True);
insert oppObj;

OpportunityTeamMember Team = new OpportunityTeamMember(Opportunityid= oppObj.id,UserID= '005A0000000T6JG',TeamMemberRole='Distributor');
insert team;

delete team;
}
}