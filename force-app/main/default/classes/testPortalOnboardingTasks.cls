@IsTest
public class testPortalOnboardingTasks  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void portalonboarding() {
         test.startTest();
        
        TriggerContextUtility.setFirstRunFalse();
        String conId ='';
        String wherestmnt = '';
        String addfields = '';
        String  orderstmnt = '';
        
        portalOnboardinggetTasks.getTasks(conId,wherestmnt,addfields,orderstmnt);
        test.stopTest();
        
        
    }
    
}