public class LOARequestController {

    @AuraEnabled(cacheable=true)
    public static Contact getUserContactInfo(){
        List<Contact> c = [select id, email, firstname, lastname, Account.Name, Account.Reseller_Certificate__c, FinchOracleId__c, Account.BillingAddress from Contact where email=:UserInfo.getUserEmail() limit 1];
           return c[0];
        

    }
    @AuraEnabled
    public static void insertLOARequest(String resellerNo, Date expDate){
        List<Contact> c = [select id, email, firstname, lastname, Account.Name, Account.Reseller_Certificate__c, FinchOracleId__c, Account.BillingAddress from Contact where email=:UserInfo.getUserEmail() limit 1];
        LOA_Request__c loa = new LOA_Request__c(Contact__c=c[0].id, Reseller_Certificate__c=resellerNo==null ? c[0].Account.Reseller_Certificate__c : resellerNo);
        loa.Reseller_Certification_Expiration_Date__c=expDate;
        insert loa;
        insert new Task(Subject='LOA Requested', Status='Completed', Priority='Normal', WhoId=c[0].id);
    }
   
    
}