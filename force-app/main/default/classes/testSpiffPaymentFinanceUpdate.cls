@isTest
private class testSpiffPaymentFinanceUpdate {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    static testmethod void getLines()
    {		        
        
        
        test.startTest();        
        Spiff_request__c sp = [Select id, status__c,product__c,Requester__c ,Requester__r.AccountId from Spiff_request__c limit 1];
        Account acc = [Select billingCountry, billingstate,id from account where id = : sp.Requester__r.AccountId limit 1];
        
        Product2 p = [Select id, family from product2 limit 1];
        p.family = 'IFP';
        update p;
        sp.Status__c = 'Approved';
        sp.product__c = p.Id;
        update sp;
        
        spiffPaymentToFinance.updateFinance();
        
        acc.BillingCountry = 'Canada';
        acc.BillingState = 'Alberta';
        update acc;
        
        sp.Status__c = 'Approved';
        update sp;
        p.family = 'CD';
        update p;
        spiffPaymentToFinance.updateFinance();
        sp.Status__c = 'Approved';
        update sp;
        p.family = 'LCD';
        update p;
        spiffPaymentToFinance.updateFinance();
        sp.Status__c = 'Approved';
        update sp;
        p.family = 'PJ';
        update p;
        spiffPaymentToFinance.updateFinance();
        sp.Status__c = 'Approved';
        update sp;
        p.family = 'IFP';
        update p;
        spiffPaymentToFinance.updateFinance();
        
        test.stopTest();
    }
}