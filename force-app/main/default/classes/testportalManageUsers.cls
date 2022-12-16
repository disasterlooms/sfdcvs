@IsTest
public class testportalManageUsers  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void searchTest() {
        test.startTest();
        Contact c = [Select id from contact limit 1];
        User u = [Select id,contactid from User where IsPortalEnabled = true limit 1];
        
        portalManageUsers.getUsers();
        portalManageUsers.inactive(c.Id, u.Id);
        
        test.stopTest();
       
    }
}