global without sharing class portalResellerOnboarding {
    @AuraEnabled
    global static List<Account> mapAccount(String cemail){
        //attempt to map the contact to the correct account
        //We can use email domain names
        //The user can map themselves to any location that is part of their email 
        //domain because that has been verified. 
        //
        //We do need a way to map to an account and/or be verified if there is no existing contact domain 
        //but there is an existing account or have a new account be created
        //we can use the account website/domain field if the email domain and website domain field match
        //
        String conDomain = cemail.substringAfter('@');
        system.debug('Domain from Contact '+ conDomain);
        
        List<Account> acc = [Select id, name, billingcity,billingstate,billingpostalcode,billingstreet,billingcountry, Parent_Account_Name__c ,ownerid,
                             website, domain__c, owner.name,phone from account where id in (select accountid from contact where email like :'%'+conDomain
                                                                                           and email != '') 
                             and name != 'Partner Portal Unverified Contacts' 
                             limit 15];
        system.debug('Account Found from Contact '+acc.size());
        
        if(acc.size() == 0 && conDomain != ''){
            acc = [Select id, name, billingcity,billingstate,billingpostalcode,billingstreet,billingcountry, Parent_Account_Name__c ,
                   website, domain__c, owner.name from account where domain__c =: conDomain and domain__c != ''
                   limit 25];
            
        }
        
        system.debug(acc);
        
        return acc;
    }
}