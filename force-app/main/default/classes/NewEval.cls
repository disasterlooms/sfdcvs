public class NewEval {
    @AuraEnabled
     public static Eval_Request__c getEval(String recid){
        system.debug('get the eval '+recid);
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get('Eval_Request__c');

        Sobject genericObject = convertType.newSObject();
        
        DescribeSObjectResult describeResult = genericObject.getSObjectType().getDescribe();
        
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        
        String query =		  ' SELECT ' +		      String.join( fieldNames, ',' ) + 
        ' , (Select id, sku__c,sku__r.name from eval_unit_details__r where Transfer_Requested__c = true '+
        ' and sku__c != null) FROM '
            +		      describeResult.getName()	+' where id =: recid limit 1' 	;		
        // return generic list of sobjects or typecast to expected type
       
        Eval_Request__c record = Database.query( query );
        system.debug('get the eval '+record);
        ///clear out all the product fiels and reiterate with the
        //products that were selected to transfer
        //limitation being spl and sample and b stock skus that could not be mapped
        //to a parent sku in Salesforce. Those skus will not be added
        //
        system.debug(record.eval_unit_details__r);
        system.debug(record.eval_unit_details__r.size());
        system.debug('above is details and then size');
        record.Product_Name_2__c = null;
        record.Product_Name_3__c = null;
        record.Product_Name_4__c = null;
        record.Product_Name_5__c = null;

        record.Quantity__c = null;
        record.Quantity_2__c = null;
        record.Quantity_3__c = null;
        record.Quantity_4__c = null;
        record.Quantity_5__c = null;
        for (Integer i = 0; i < record.eval_unit_details__r.size(); i++) {
            if(i==0){
                system.debug('first sku '+record.eval_unit_details__r[i].Sku__r.Name);
                record.product_name__c = record.eval_unit_details__r[i].Sku__c;
                record.Quantity__c = 1;
            }
            if(i==1){
                system.debug('2nd sku '+record.eval_unit_details__r[i].Sku__r.name);
                record.Product_Name_2__c = record.eval_unit_details__r[i].Sku__c;
                record.Quantity_2__c = 1;
            }
            if(i==2){
                system.debug('3rd sku '+record.eval_unit_details__r[i].Sku__r.name);
                record.Product_Name_3__c = record.eval_unit_details__r[i].Sku__c;
                record.Quantity_3__c = 1;
            }
            if(i==3){
                record.Product_Name_4__c = record.eval_unit_details__r[i].Sku__c;
                record.Quantity_4__c = 1;
            }
            if(i==4){
                record.Product_Name_5__c = record.eval_unit_details__r[i].Sku__c;
                record.Quantity_5__c = 1;
            }
        }
        
        system.debug(record.Quantity__c);
        system.debug(record.product_name__c);
        return record;
         
    }
    
    @AuraEnabled
     public static String getUser()
    {     
         Id userId = UserInfo.getUserId();
         
         Contact con = [SELECT ID, Name FROM Contact WHERE UserID__c = :userId limit 1];
         
         return con.Id;
         
    }
    @AuraEnabled
    public static List<String> getTypes(Boolean trade)  
  {
        List<String> options = new List<String>();
      
		options.add('--None--');
        Schema.DescribeFieldResult fieldResult = Eval_Request__c.Eval_Type__c.getDescribe();
    
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    
       if(trade != true || trade == null){  
           for (Schema.PicklistEntry f: ple){
                options.add(f.getValue());
           }
       }else{
            for (Schema.PicklistEntry f: ple) {
                if(f.getValue() !='Reseller Demo' && f.getValue() != 'Write Off Request' ){
                     options.add(f.getValue());
                }               
       		}
       }
	  system.debug('options');
      system.debug(options);         
       
      return options;
    }

}