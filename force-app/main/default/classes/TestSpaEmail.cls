@isTest
private class TestSpaEmail {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void spaemail()  
    {
         
        
        test.startTest();
        Quote q = [Select id,name from quote limit 1];
        String recid = q.id;
        String spaid = q.name;
        String quoteid = q.id;
        String wherestmnt = '';
        String addfields = '';
        String orderstmnt = '';
          
        EmailMessage e = new EmailMessage(subject = 'Need Info for SPA',
                                          ToAddress  = UserInfo.getUserEmail(),
                                          RelatedToId = q.Id);
        
        
        insert e;
        SpaMessages.getMessage(recid);
        SpaMessages.getOppLines(quoteid, wherestmnt, addfields, orderstmnt);
        SpaMessages.getMessagefromspa(spaid);
        
        test.stopTest();
        
    }
}