public class SpaProducts {
    @AuraEnabled
    public static List<QuoteLineItem> getOppLines(String quoteid,String wherestmnt,String addfields,string orderstmnt){
        system.debug('oppid is ' +quoteid);   
        
        DescribeSObjectResult describeResult = QuoteLineItem.getSObjectType().getDescribe();
        
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        String query =		  ' SELECT ' +		      String.join( fieldNames, ',' ) +	addfields +	  ' FROM '
            +		      describeResult.getName()	+' WHERE QuoteId = : quoteid '+ wherestmnt+ orderstmnt;		
        // return generic list of sobjects or typecast to expected type
        
        List<SObject> records = Database.query( query );		
        System.debug( records );
        
        return records;
    }
    @AuraEnabled
    public static List<QuoteLineItem> updateOppLines(List<QuoteLineItem> lineitems, String quoteid){
        
        try{
             update lineitems;
        }catch(Exception e){
             throw new AuraHandledException('Darn it! Something went wrong: '+ e.getMessage()); 
        }      
       
        
        return [SELECT Id,product2.name,Quantity,Ship_Out_Date__c,QuoteId,unitprice,totalprice,
                Status__c
                FROM QuoteLineItem
                WHERE QuoteId = :quoteid];
        
        
    }
    @AuraEnabled
    public static List<QuoteLineItem> deleteOppLines(List<QuoteLineItem> dlineitems, String quoteid){
        system.debug('prods ' +dlineitems);
        
        system.debug(dlineitems);
        try{
            delete  dlineitems;
        }catch(Exception e){
             throw new AuraHandledException('Darn it! Something went wrong: '+ e.getMessage()); 
        }
        
         return [SELECT Id,product2.name,Quantity,Ship_Out_Date__c,QuoteId,unitprice,totalprice,
                Status__c
                FROM QuoteLineItem
                WHERE QuoteId = :quoteid];
        
        
    }
    
}