public class productTypes {
@AuraEnabled
    public static List<String> getProdTypes()  
  {
        List<String> options = new List<String>();
        options.add('--None--');
        
        List<Product_Manager__c> pillars = [Select Id, Name from Product_Manager__c];
    
        for (Product_Manager__c p: pillars) {
            options.add(p.name);
        } 
        system.debug('options');      
       
      return options;
    }
}