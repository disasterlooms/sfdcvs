@isTest
public class TestEvalContacts {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    //passed 10.27.2021
 
    Static testmethod void TestEvalContact () {
        
         test.startTest();
        
        Contact c = [Select id, name,firstname,lastname,email,phone,mailingstreet,mailingcity,mailingstate,
                             mailingpostalcode,mailingcountry,title,Account.Type, Account.Industry,
                             Account.Owner.Name,Account.BillingStreet,Account.BillingCity,Account.BillingState,Account.BillingPostalCode,
                             Account.BillingCountry from contact where accountid != null and name !='tonythetester' limit 1];
        
        Opportunity o = [Select id from opportunity limit 1];
        system.debug('contact data for eval');
        
        system.debug(c);
        
        
        Eval_Request__c e = new Eval_Request__c(Expected_Receive_Date__c = date.today(),
                                               opportunity_name__c = o.Id);
        insert e;
        
        String recid = e.Id;
        EvalContacts.getRelatedRecords(recid);
        EvalContacts.checkShipping(c);
        EvalContacts.checkBilling(c);
        EvalContacts.getEval(e);
        test.stopTest();
        
    }    

}