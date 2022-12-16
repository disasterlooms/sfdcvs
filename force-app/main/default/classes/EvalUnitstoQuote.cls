public class EvalUnitstoQuote { 
    /// Adding a method getaccesscheck to Check Custom Permission on the Profile
     @AuraEnabled
    public static Boolean getAccessCheck(){
        Boolean hasPermission = FeatureManagement.checkPermission('Eval_Special_Price_Access');
        return hasPermission;
    }
    @AuraEnabled
    public static List<Eval_Unit_Details__c> getUnits(String recordId){
        
        DescribeSObjectResult describeResult = Eval_Unit_Details__c.getSObjectType().getDescribe();
        
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        String query =		  ' SELECT ' +		      String.join( fieldNames, ',' ) +		  ', SKU__r.Name  FROM '
            +		      describeResult.getName()	+' WHERE Eval_Request__c  = : recordId'	;		
        // return generic list of sobjects or typecast to expected type
        
        List<Eval_Unit_Details__c> records = Database.query( query );		
        System.debug( records );
        
        return records;
    }
     @AuraEnabled
    public static void updateUnits(List<Eval_Unit_Details__c> units, String quoteId){
        for(Eval_Unit_Details__c e : units){
            e.Eval_Quote__c = quoteid;
        }
        update units;
    }
    @AuraEnabled
    public static List<Eval_Unit_Details__c> updateSelected(List<Eval_Unit_Details__c> units){
        system.debug('units to Update Shpping Return ');
        /*
        for(Eval_Unit_Details__c e : units){
            e.Unit_Selected__c  = true;
        }
        */
        update units;
        return units;
    }

}