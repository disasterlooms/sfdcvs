public without sharing class portalOnboardinggetTasks {
    @AuraEnabled
    public static List<PortalOnboardingProgress__c > getTasks(String conId,String wherestmnt,
                                                              String addfields,string orderstmnt){
        system.debug('contact id is ' +conId); 
        User u = [select id, contactId from user where id = : userinfo.getUserId() limit 1];                                                          
                                                                  if(conid =='' || conid == null){
                                                                      conid = u.contactId;
                                                                  }                                                          
        // With the contact id get all related assigned tasks and return them in one sObject
        // to lightning component to iterate over 
        // leaving order stnment and add fields and where statement for the component to control certain 
        // aspects without having to rebuild the query in apex. 
        // 
        // 
        
        DescribeSObjectResult childResult = PortalOnboardingProgress__c.getSObjectType().getDescribe();
        DescribeSObjectResult parentResult = Portal_Task__c.getSObjectType().getDescribe();
        DescribeSObjectResult acct = Account.getSObjectType().getDescribe();
        DescribeSObjectResult cont = Contact.getSObjectType().getDescribe();
        
        
        List<String> fieldNames = new List<String>( childResult.fields.getMap().keySet() );
        List<String> pfieldNames = new List<String>( parentResult.fields.getMap().keySet() );
        List<String> afieldNames = new List<String>( acct.fields.getMap().keySet() ); 
        List<String> cfieldNames = new List<String>( cont.fields.getMap().keySet() ); 
        
        
        system.debug(pfieldNames);
        List<String> parentfieldNames = new List<String>();
        List<String> acctountfieldNames = new List<String>();
        List<String> contactfieldNames = new List<String>();
        
        // add the parent object field name to each field and then add to the query 
        // 
        for(String p : pfieldNames){
            p = 'Partner_Portal_Task__r.'+p;
            parentfieldNames.add(p);
        }
        
        for(String pa : afieldNames){
            pa = 'Portal_Account__r.'+pa;
            acctountfieldNames.add(pa);
        }
        
        for(String pc : cfieldNames){
            pc = 'Portal_Contact__r.'+pc;
            contactfieldNames.add(pc);
        }
        
        
        String query =		  ' SELECT ' +		      String.join( fieldNames, ',' )+','+String.join( parentfieldNames, ',' ) +','+String.join( acctountfieldNames, ',' ) +
            ','+String.join( contactfieldNames, ',' )	  + addfields +	  ' FROM '
            +		      childResult.getName()	+' WHERE Portal_Contact__c  = : conId '+ wherestmnt+ orderstmnt;
        system.debug(query);
        List<SObject> records = Database.query( query );
        
       
        System.debug( records );
        
        return records;
    }
}