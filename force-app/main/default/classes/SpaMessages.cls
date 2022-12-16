public without sharing class SpaMessages {
    @AuraEnabled
    public static List<EmailMessage> getOppLines(String quoteid,String wherestmnt,String addfields,string orderstmnt){
        system.debug('oppid is ' +quoteid);   
        
        DescribeSObjectResult describeResult = EmailMessage.getSObjectType().getDescribe();
        
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        String query =		  ' SELECT ' +		      String.join( fieldNames, ',' ) +	addfields +	  ' FROM '
            +		      describeResult.getName()	+' WHERE RelatedToId = : quoteid '+ wherestmnt+ orderstmnt;		
        // return generic list of sobjects or typecast to expected type
        
        List<SObject> records = Database.query( query );		
        System.debug( records );
        
        return records;
    }
     @AuraEnabled
    public static SObject getMessage(String recid){
    
    DescribeSObjectResult describeResult = EmailMessage.getSObjectType().getDescribe();
        
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        String query =		  ' SELECT ' +		      String.join( fieldNames, ',' )  +	  ' FROM '
            +		      describeResult.getName()	+' WHERE Id = : recid ';		
        // return generic list of sobjects or typecast to expected type
        
        List<SObject> records = Database.query( query );		
        System.debug( records );
        if(records.size() > 0){
          return records[0];  
        }else{
            return null;
        }
            
    
    }
    
     @AuraEnabled
    public static String getMessagefromspa(String spaid){
    
        List<Quote> q = [Select id,name from quote where name =: spaid limit 1];        
        String quoteid = '';        
        if(q.size()>0){
            quoteid = q[0].Id;
            system.debug('name and id '+q[0].id+' '+q[0].name);
        }
        return quoteid;      
    
    }
}