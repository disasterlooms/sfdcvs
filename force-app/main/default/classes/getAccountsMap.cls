public class getAccountsMap {
    @AuraEnabled
    public static List<Account> getaccts(String city,String state,String zip,
                                        String ind, String acctType,Double classSize,
                                        Double rev ,Boolean focus,Double rank,String limitstmnt,
                                       String orderstmnt,String wherestmnt,String county){
                                            
        
       ind = '%'+ind+'%';
       city = '%'+city+'%';
       state = '%'+state+'%';
       zip = '%'+zip+'%';
       acctType = '%'+acctType+'%';                                     
       county = '%'+county+'%';                                    
                                           
                                           
        DescribeSObjectResult describeResult = Account.getSObjectType().getDescribe();
        
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
            String query =      ' SELECT ' +          String.join( fieldNames, ',' )  +
            ' ,(Select id,name, email,phone,title from Contacts limit 3) FROM '
            +          describeResult.getName()  +' WHERE Industry like :ind and billingcity like : city  and billingpostalcode like: zip'
            +' and billingstate like : state and county__c like : county     '+
            '  '+ 
            wherestmnt + orderstmnt +' '+ limitstmnt;  
                                           
        system.debug('query');
        system.debug(query);
                                           
        List<SObject> accts = Database.query( query );    
        System.debug( accts );
        
        return accts;
                                           
    }
    
    @AuraEnabled
    public static List<School__c> getSchoolssMap(List<Account> acctIds) {
        
        DescribeSObjectResult describeResult = School__c.getSObjectType().getDescribe();
        
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        String query =      ' SELECT ' +          String.join( fieldNames, ',' )  +    ' FROM '
            +          describeResult.getName()  +' WHERE account__c in:  acctIds order by Postal_Code__c desc nulls last  limit 50';    
        
        List <School__c> schls = Database.query( query );
        system.debug(schls);
        return schls;
        
    }
}