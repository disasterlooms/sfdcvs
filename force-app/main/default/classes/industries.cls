public class industries {
@AuraEnabled
    public static List<String> getIndustries()  
  {
        List<String> options = new List<String>();
        options.add('--None--');
        Schema.DescribeFieldResult fieldResult = Account.Industry.getDescribe();
    
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getValue());
        } 
        system.debug('options');      
       
      return options;
    }
}