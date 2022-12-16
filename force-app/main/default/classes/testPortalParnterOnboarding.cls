@IsTest
public class testPortalParnterOnboarding {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void testPortalComponent() {
        test.startTest();
        User u = [Select id,email from user where isactive = true
                   and profile.UserType  = 'Standard' limit 1];
        String cemail = u.email;
        portalResellerOnboarding.mapAccount(cemail);
        test.stopTest();
        
    }
}