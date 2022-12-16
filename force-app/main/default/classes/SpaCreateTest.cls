@isTest
private class SpaCreateTest {
    
    static testmethod void SpaCreateTest() {
        // set up some test data to work with
        Test.Starttest();
        SpaCreate.create();        
        Test.stopTest();
    }
}