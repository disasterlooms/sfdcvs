@IsTest
public class testResetPassword {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void testPortalComponent() {
        test.startTest();
        User u = [Select id from user where isactive = true
                   and profile.UserType  = 'Standard' limit 1];
        String userid = u.Id;
        resetPassword.resetP(userid);
        test.stopTest();
        
    }
}