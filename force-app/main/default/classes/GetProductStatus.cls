public class GetProductStatus {
    @AuraEnabled
    public static List<String> getStatus()  
  {
        List<String> options = new List<String>();
		options.add('--None--');
        Schema.DescribeFieldResult fieldResult = OpportunityLineItem.Status__c.getDescribe();
    
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getValue());
        } 
		system.debug('options');      
       
      return options;
    }

}