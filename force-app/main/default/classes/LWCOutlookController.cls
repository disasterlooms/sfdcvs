public without sharing class LWCOutlookController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> ServiceItemLookupByEmail(String emailAddress){ 
      System.debug('Running LWCOutlookController.ServiceItemLookupByEmail');      
      System.debug('Input email address=' + emailAddress);
     
      List <Contact> cons = [SELECT id,email,name ,AccountId
                                    FROM Contact 
                                    WHERE email = :emailAddress];
        system.debug(cons);

                return cons;

    }
}