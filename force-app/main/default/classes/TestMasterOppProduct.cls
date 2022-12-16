@IsTest
public class TestMasterOppProduct  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void MasterOppProductInsert() {
        
        //Opportunity o = [Select Id,Pricebook2Id,SPA_ID__c from Opportunity where Spa_Stage__c != null limit 1];
        
        //Quote q = new Quote(OpportunityId = o.id,Pricebook2Id=o.pricebook2id,name = o.SPA_ID__c);
        //insert q;
        
        //OpportunityLineItem op = new OpportunityLineItem(OpportunityId = o.id,
                                                         //Quantity = 5,
                                                        //UnitPrice =30,
                                                        //Pricebookentryid = [Select Id from Pricebookentry where
                                                                           //isactive = true and Pricebook2id =: o.Pricebook2id limit 1].id);
        test.startTest();
        //insert op;
        test.stopTest();
        
        
    }
}