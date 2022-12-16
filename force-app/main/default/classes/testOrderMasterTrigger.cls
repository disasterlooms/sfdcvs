@isTest
private class testOrderMasterTrigger{
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void orderTrigger() {        
        test.startTest();
        Opportunity opp = [Select id , spa_Id__c from opportunity limit 1];
        
        Quote q1 = new Quote();
        q1.OpportunityId = opp.Id;
        q1.Name = opp.spa_Id__c;
        insert q1;
        
        Quote q = [Select id,OpportunityId,AccountId,Name from Quote where id =: q1.Id limit 1];   
        
        Account a = [Select id from account where id = : q.AccountId limit 1];
        system.debug('Quote info '+q.Name +' '+q.OpportunityId+' '+q.AccountId);
        Order o = new Order();
        o.Status = 'Draft';
        o.Contact_Name__c = 'john';
        o.Named_Location_of_Training__c  = 'testing';
        o.AccountId = a.Id;
        o.EffectiveDate = date.today();
        o.SpaNumber__c = q.Name;
        insert o;
        
        
        
        Order ordTest = [Select id, opportunity__c,AccountId,SpaNumber__c,quoteid, Objective_1__c   from Order where id = : o.Id limit 1];
        Id qt = ordTest.quoteid;
        
        ordTest.quoteid = null;
        update ordTest;
        TriggerContextUtility.setFirstRunTrue(); 
        ordTest.quoteid = qt;
        update ordTest;
        
        
        test.stopTest();
       
        system.debug('test acct id, opp id , spa name '+ordTest.SpaNumber__c+' '+ordTest.Opportunity__c+ ' '+ordTest.AccountId);
        system.assertEquals(q.AccountId, ordTest.AccountId);
        system.assertEquals(q.OpportunityId, ordTest.opportunity__c );
        
    }
}