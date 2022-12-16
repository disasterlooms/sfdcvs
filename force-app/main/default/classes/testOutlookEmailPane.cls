@isTest
private class testOutlookEmailPane {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void getEmailrecords()  
    {
        test.startTest();
        List<String> emails = new List<String>();
        List<OpportunityContactRole> cons = [Select contact.email from OpportunityContactRole limit 1];
        for(OpportunityContactRole c : cons){
            emails.add(c.contact.email);
        }
        String emailfrom = cons[0].contact.email;
        
        OutlookEmailPane.getContacts(emails,emailfrom);
        OutlookEmailPane.getOpps(emails,emailfrom);
        OutlookEmailPane.getEvals(emails,emailfrom);
        OutlookEmailPane.getCases(emails,emailfrom);
        
        test.stopTest();
    }
}