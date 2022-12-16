@isTest
private class TestAccountVIP {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
     }
  
    static testmethod void accountVIP()
    {		        
        test.startTest();
        Account a = [Select Id,VIP_Service_Reason_for_Request__c,VIP_in_Approval_Process__c  from Account limit 1];
        String recid = a.Id;        
        AccountVIPService.getStatus(recid);
        AccountVIPService.vip(recid);
        test.stopTest();
    }
    
    static testmethod void accountHotline()
    {		        
        test.startTest();
        Account a = [Select Id,VIP_Service_Reason_for_Request__c,VIP_in_Approval_Process__c  from Account limit 1];
        String recid = a.Id;        
        AccountVIPService.getStatus(recid);                     
        AccountVIPService.hotline(recid);
        test.stopTest();
    }
}