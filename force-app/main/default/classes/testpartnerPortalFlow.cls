@IsTest
public class testpartnerPortalFlow {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void testPortalComponent() {
        test.startTest();
        GenericEmails__c gm = new GenericEmails__c(name ='gmail.com');
        insert gm;
        
        String thedomain = 'gmail.com';
        Boolean isGeneric =  partnerPortalFlow.getDomain(thedomain);
        test.stopTest();
        system.assertEquals(true, isGeneric);
        
    }
    Static testmethod void testgetCode() {
        test.startTest();
        
        Integer theCode =  partnerPortalFlow.getCode();
        test.stopTest();
        system.assertEquals( String.valueOf(theCode).length(), 5);
        
    }
    
}