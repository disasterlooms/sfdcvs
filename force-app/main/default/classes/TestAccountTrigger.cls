@isTest
private class TestAccountTrigger{
    public Set<String> accntIds = null; 
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }

    static testmethod void AccountAssignmentTest() {
        test.startTest();
        Account edu = [Select id, GetVSContacts__c,Industry from Account where Industry != 'Education - Higher Education' limit 1];
        TriggerContextUtility.setFirstRunTrue();
        edu.Industry = 'Education - Higher Education';        
        edu.Focus_Account__c = true;
        update edu;
        Set<String> newIds = new Set<String>();
        newIds.add(edu.Id);
        queueOwnerAssign updateJob = new queueOwnerAssign(newIds);
        System.enqueueJob(updateJob);
        test.stopTest();
        
        
    }
    static testmethod void AccountTrigger() {
        portalProfileUpdate.doChainJob = false;
        test.startTest();
        Account edu = [Select id, GetVSContacts__c,Industry from Account where Industry != 'Education - Higher Education' limit 1];
        TriggerContextUtility.setFirstRunTrue();
        
        
        edu.Industry = 'Education - Higher Education';        
        edu.Focus_Account__c = true;
        update edu;
        
        system.debug(edu.Industry +' high ed '+edu.Id+ ' firstvrun '+TriggerContextUtility.isFirstRun());
        //run test on acct owners assign until it desctructive change made
        //
        
        Account a = new Account();
        AccountOwnerAssign assn = new AccountOwnerAssign();
        assn.assignAcctOwner(a);
        
        test.stopTest();
        
        
    }
    static testmethod void AccountTriggerUpdates() {
        portalProfileUpdate.doChainJob = false;
        TriggerContextUtility.setFirstRunTrue();
        
        Boolean fr = TriggerContextUtility.isFirstRun();
        system.debug('is this now first run ? '+fr);
        
        Test.startTest();
        Account a = [Select Id,BillingStreet,GetVSContacts__c,BillingCity,BillingState from Account
                     where BillingCity != null limit 1];
        
        List <Account> var = [Select Id, BillingState from Account where Type != 'VAR'
                              and name != 'ViewSonic Corporation'];
        
        List <Account> edu = [Select Id, BillingState,focus_account__c from Account where Industry != 'Education - Higher Education'
                              and name != 'ViewSonic Corporation' and 
                              Type = 'End User'];
        
        
        County__c c = new County__c (Name='County',StateCode__c = a.BillingState, City__c = a.BillingCity);
        insert c;
        
        a.BillingStreet ='new street testing lane';
        update a;
        
        TriggerContextUtility.setFirstRunTrue();
        a.GetVSContacts__c = true;
        update a;
        TriggerContextUtility.setFirstRunTrue();
        var[0].Type = 'VAR';
        database.update (var,false);
        
        County__c cnt = new County__c();
        cnt.name = 'CountyName';
        cnt.City__c = 'Long Beach';
        cnt.StateCode__c = 'CA';
        
        insert cnt;
        
        
        
        Account adel = new Account(Name = 'test delete focus',
                                   Type = 'End User',
                                   industry = 'Business',                                   
                                   Focus_account__c = true,
                                   BillingState = 'California',
                                   BillingStateCode = 'CA',
                                   BillingCountryCode = 'US',
                                   BillingCity = 'Long Beach',
                                   website = 'www.redhat3434.com');
        insert adel;
        
        Account adel2 = new Account(Name = 'test delete focus',
                                    Type = 'VAR',
                                    industry = 'Business',
                                    Focus_account__c = true,
                                    BillingState = 'California',
                                    BillingCity = 'Long Beach',
                                    BillingCountryCode = 'US',
                                    website = 'redhat352345.com');        
        
        Database.DMLOptions dml = new Database.DMLOptions(); 
        dml.DuplicateRuleHeader.allowSave = true;
        Account duplicateAccount = adel2;
        Database.SaveResult sr = Database.insert(duplicateAccount, dml);
        
        String adelId = adel.Id;
        //need to test that focus account does not delete 
        //also checking if I can delete an account that is not focus
        //
        
        try{
            delete adel;  
        }catch(Exception e){
            system.debug('exception '+ e);
        }
        
        
        List <Account> adelQ = [Select Id, BillingState,focus_account__c from Account where name = 'test delete focus' limit 1];
        
        String adelFail = adelQ[0].Id;
        adel.Focus_account__c = false;
        update adel;
        delete adel;
        
        Test.stopTest();
        system.assertEquals(adelId, adelFail);
        Account aFD = new Account ();
        aFD.Name = 'FRESHDESK_UNKNOWN_COMPANY';
        
        try{
            insert aFd;
        }catch(Exception e){
		}
        
        
    }
    static testmethod void testchainedQueableAcctContactOwner() {
        TriggerContextUtility.setFirstRunTrue();
        List <Account> records = [Select Id from Account where name != 'ViewSonic corp' limit 10];
        Set<String>  accntIds = new Set<String>();
        for(Account a : records){
            accntIds.add(a.Id);
        }
        accountContactOwner rTr = new accountContactOwner(accntIds);
            System.enqueueJob(rTr); 
        triggerContextUtility.setGlobalTriggersFalse();
        triggerContextUtility.setGlobalTriggersTrue();
        Boolean cool = triggerContextUtility.isglobalTriggers();
        
        
    }
    
    static testmethod void testterritoryrules() {
        TriggerContextUtility.setFirstRunTrue();
        List <Account> records = [Select Id from Account where name != 'ViewSonic corp' limit 10];
        Set<String>  accntIds = new Set<String>();
        for(Account a : records){
            accntIds.add(a.Id);
        }
        RunTerritoryRules rTr = new RunTerritoryRules(accntIds);
            System.enqueueJob(rTr); 
        
        
    }
    
}