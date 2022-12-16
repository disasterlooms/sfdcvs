@isTest
public class TestOppTeams {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    public static testMethod void OppTeams() {
        
        test.starttest();
        
        Opportunity opp = [Select id,AccountId,OwnerId, name from opportunity limit 1];
        
        PageReference myVfPage = Page.OppTeams;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
        
        ApexPages.currentPage().getParameters().put('id',opp.id);
        String id = ApexPages.currentPage().getParameters().get('id');
        //system.assertEquals(true,id!=null);
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Opp);
        OppTeams ac = new OppTeams(sc);
        //PageReference myVfPage = 
        
        ac.updateteam();
        
        test.stoptest();
    }
}