@isTest
public class TestOppReseller {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void getResellers()
    {
        
        test.startTest();
        Opportunity opp = [Select id from opportunity where Partner_Account_Search__c != null limit 1];
        OppReseller.getReseller(opp.id);
        
    }
    
}