public without sharing class getAccountsConsSpa {
    //12.9.19 notes added 2 methods. Intead of returning string, returning entire
    //object of vsaopen orders so we can get the entire object in case we need to get more 
    //data. 
    //
    //added opportunityid as a method so we can use opportunity related components on different pages
    //
    //
    @AuraEnabled
    public static Account getAccount(String spaid){
        Account a = [Select id, name, industry, Type, owner.name, billingstate
                    from account where id in (Select AccountId from Quote where 
                                             Name = : spaid or Opportunity.Spa_Id__c = : spaid)];
        return a;        
    }
    @AuraEnabled
    public static List<Sobject> getAccountPO(String ponumber){
        List<sObject> retObjects = new List<sObject>();
        
        DescribeSObjectResult describeResult = VSA_Open_Order__c.getSObjectType().getDescribe();
        
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        String query =		  ' SELECT ' +		      String.join( fieldNames, ',' ) +	  ' FROM '
            +		      describeResult.getName()	+' WHERE PO_Number__c  = : ponumber ';		
        // return generic list of sobjects or typecast to expected type
        
        List<VSA_Open_Order__c> records = Database.query( query );	
        
        VSA_Open_Order__c oo = records[0];
        
        /*
        VSA_Open_Order__c oo = [Select Ship_to_Instructions__c ,Packing_Instructions__c , Spa_Number__c ,status__c, Product__c,
                                 Ship_to_Address_2__c ,Ship_to_Name__c ,Ship_Zip__c ,SpaId__c, Ship_State__c 
                                from VSA_Open_Order__c  where 
                                             PO_Number__c  = : ponumber limit 1];
      */
        
        retObjects.add(oo);
        
        Account a = new Account();
        Opportunity opp = new Opportunity();
        
        try{
            a = [Select id, name, industry, Type, owner.name, billingstate,
                     (select id, firstname,lastname, phone,email, Title,Marketing_Post_Sales__c,
                              Account.Name,MailingState,Account.Parent.Name from contacts) 
                    from account where id in (Select AccountId  from Quote where name = : oo.Spa_Number__c)];
            
        }catch(exception e){
            a = null;
        }
        
         
        
        retObjects.add(a);
        
        
        try{
            opp = [Select Id,name,createddate,closedate,account.name,opportunity.owner.name
                         from opportunity where id in (Select opportunityId from Quote where name = : oo.Spa_Number__c) limit 1 ];
        
            
        }catch(exception e){
            opp = null;
        }
        
        
        retObjects.add(opp);
        
        return retObjects;
        
    }
     @AuraEnabled
    public static VSA_Open_Order__c getShippingInstPackingInst(String ponumber){
        VSA_Open_Order__c a = [Select Ship_to_Instructions__c ,Packing_Instructions__c , Spa_Number__c ,status__c, Product__c 
                               from VSA_Open_Order__c  where 
                                             PO_Number__c  = : ponumber limit 1];
        
        return a;
    }
        

         @AuraEnabled
    public static Opportunity getOpportunity(String ponumber){
        
        VSA_Open_Order__c oo = [Select Spa_Number__c   from VSA_Open_Order__c  where 
                                             PO_Number__c  = : ponumber limit 1];
        
        Opportunity a = [Select Id,name,createddate,closedate,account.name,opportunity.owner.name
                         from opportunity where id in (Select opportunityId from Quote where name = : oo.Spa_Number__c) limit 1 ];
        
        return a;
    }
    
    @AuraEnabled
    public static String getShippingInst(String ponumber){
        String ship = '';
        VSA_Open_Order__c a = [Select Ship_to_Instructions__c , Spa_Number__c ,status__c  from VSA_Open_Order__c  where 
                                             PO_Number__c  = : ponumber limit 1];
        ship = a.Ship_to_Instructions__c;
        return ship;
        
    }
}