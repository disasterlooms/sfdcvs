public class OutlookEmailPane {
    /*
this will get related contacts, accounts, opportunities, cases and evals. 
*/    
    @AuraEnabled
    public static List<Account>  getContacts(List<String> emails,String emailfrom) {
        List<Account> cons = [SELECT id, Name, parent.name, CreatedDate,BillingState,BillingCity,Type,
                              BillingPostalCode,(Select id, name, title, phone,email from contacts where email IN :emails
                                                or email =: emailfrom)
                              FROM Account 
                              WHERE id in (Select AccountId from Contact where email IN :emails or email =: emailfrom) ];
        system.debug('cons and emails');
        system.debug(cons);
        system.debug(emails);
        system.debug(emailfrom);
        
        return cons;
    }
    
    /*
get the opportunities that have a reseller contact or contact role relating to the email addresses
*/
    @AuraEnabled
    public static List<Opportunity> getOpps(List<String> emails,String emailfrom) {
        
        List<Opportunity> oppcons = [Select id, name, closedate, stagename, createddate,Resellers_and_Type__c ,owner.name, account.name,
                                     account.billingstate from opportunity where id in (SELECT opportunityId 
                                                                                        FROM OpportunityContactRole 
                                                                                        WHERE Contact.Email IN :emails
                                                                                        or Contact.Email =: emailfrom) ];
        
        List<Opportunity> oppparts = [Select id, name, closedate, stagename, createddate,owner.name,Resellers_and_Type__c , account.name,
                                      account.billingstate from opportunity where id in (SELECT opportunity__c 
                                                                                         FROM Opportunity_partner__c 
                                                                                         WHERE Reseller_Contact__r.Email IN :emails
                                                                                         or Reseller_Contact__r.Email =: emailfrom) ];
        
        //combine both lists and then deduplicate by putting in set and back into a list to return
        Set<Opportunity> allopps = new Set<Opportunity>();
        List<Opportunity> opps = new List<opportunity>();
        allopps.addall(oppcons);
        allopps.addall(oppparts);
        opps.addall(allopps);
        
        system.debug('opps cons, parts, all, opps, and emails');
        system.debug(emails);
        
        system.debug(oppcons);
        system.debug(oppparts);
        system.debug(allopps);
        system.debug(opps);
        
        return opps;
    }
    @AuraEnabled
    public static List<Eval_Request__c> getEvals(List<String> emails,String emailfrom) {
        List<Eval_Request__c> evals = new List<Eval_Request__c>();
        
        List<Eval_Request__c> billevals = [Select id, name, Shipping_Contact_Name__c,Eval_Type__c ,Billing_Contact_Name__r.account.name, Billing_Contact_Name__r.name, Billing_Contact_Name__r.email,
                                          Shipping_Contact_Name__r.account.name,Opportunity_Name__r.name, Shipping_Contact_Name__r.name, Shipping_Contact_Name__r.email, Eval_Process_Stage__c  
                                           from Eval_Request__c where Eval_Process_Stage__c != 'Closed' and Eval_Process_Stage__c != 'Cancelled' 
                                           and Eval_Type__c != 'ViewSonic Sales Rep Eval'
                                           and Eval_Type__c != ''
                                           and  Billing_Contact_Name__r.email != 'jason.orbison@viewsonic.com'
                                           and  Billing_Contact_Name__r.email != 'sfdcadmin@viewsonic.com'
                                           and (Billing_Contact_Name__r.email in : emails
                                           or Billing_Contact_Name__r.email = : emailfrom) ];
        
        List<Eval_Request__c> shipevals =[Select id, name, Shipping_Contact_Name__c,Eval_Type__c ,Billing_Contact_Name__r.account.name, Billing_Contact_Name__r.name, Billing_Contact_Name__r.email,
                                          Shipping_Contact_Name__r.account.name,Opportunity_Name__r.name, Shipping_Contact_Name__r.name, Shipping_Contact_Name__r.email, Eval_Process_Stage__c  
                                          from Eval_Request__c where Eval_Process_Stage__c != 'Closed' and Eval_Process_Stage__c != 'Cancelled'
                                          and Eval_Type__c != 'ViewSonic Sales Rep Eval'
                                          and Eval_Type__c != ''
                                          and Shipping_Contact_Name__r.email != 'jason.orbison@viewsonic.com'
                                          and Shipping_Contact_Name__r.email != 'sfdcadmin@viewsonic.com'
                                          and (Shipping_Contact_Name__r.email in : emails
                                               or Shipping_Contact_Name__r.email = : emailfrom)];
        
        Set<Eval_Request__c> allevals = new Set<Eval_Request__c>();
        allevals.addall(billevals);
        allevals.addall(shipevals);
        evals.addall(allevals);
        
        system.debug(emails);
        system.debug(billevals);
        system.debug(shipevals);
        system.debug(allevals);
        system.debug(evals);
        system.debug('size of set then list');
        system.debug(allevals.size());        
        system.debug(evals.size());
        
        
        return evals;
    }
    @AuraEnabled
    public static List<Case> getCases(List<String> emails,String emailfrom) {
        List<Case> cases = [Select id, subject, owner.name, createdby.name, status 
                            from case where (owner.email in : emails or owner.email = : emailfrom)
                            and subject != '' and owner.name != 'SFDC Admin' and status != 'Closed'];
        
        
        return cases;
        
    }
    
}