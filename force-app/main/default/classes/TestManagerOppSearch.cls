@IsTest
public class TestManagerOppSearch {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void ManagerOppSearch(){
        User u = [Select Id from User where IsActive = true and Profile.Name Like '%RBM%' Limit 1]; 
        System.runAs(u) {
            test.startTest(); 
            PageReference myVfPage = Page.OppsManagers;
            Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference
            
            ManagerOppSearch ac = new ManagerOppSearch();
            ac.getopps();
            ac.updateopps();
            ac.getdatepicker();
            ac.clearmessages();
            test.stoptest();
        }
    }
}