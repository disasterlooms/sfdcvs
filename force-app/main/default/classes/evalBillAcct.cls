public class evalBillAcct {
    @AuraEnabled
     public static Account getbillAcct(String evalid)
    {   
       Eval_Request__c e = [Select id,Billing_Contact_Name__r.AccountId from eval_request__c where id = :evalid limit 1];
        
        Account a = [Select Id, Name,Phone,Type,BillingAddress,BillingStreet,BillingCity,BillingState,
                     BillingPostalCode,BillingCountry,Industry
                     from Account where id =: e.Billing_Contact_Name__r.AccountId limit 1];
        //String acctid = e.Billing_Contact_Name__r.AccountId;
        
        return a;
    }
    @AuraEnabled
     public static Account updateAcct(Account acct)
    { 
        update acct;
        
        return acct;
    }

}