global class ProductAccessories implements Schedulable{
     global void execute(SchedulableContext sc)
    {
        List <Accessories__c> accs = [SELECT Id, Main_Product__r.Name, Accessory_Product__r.name
                                 ,Accessory_Product__r.Main_Products__c FROM Accessories__c ];
                                    
        //List<CMRSales__CMRCompany__c> records = [Select Name from CMRSales__CMRCompany__c limit 10];
        
        Set<String> accsset= new Set<String>();
        for (Accessories__c ac: accs) accsset.add(ac.Accessory_Product__c);
        
        //Doing a conditional if statement instead of a map
        //This may take some time to go through entire product collection may 
        //need to find more elegant way to perform but since this is scheduled
        //it is asynchronous and should fine. Ran test and it is 2088 out of 10000 cpu time.
        
        //products list are products that are accessories
        List <Product2> products = [Select Id,Main_Products__c	 from Product2 where Id in: accsset ];
       system.debug(products.size());
        system.debug('accessories: '+accsset);
        List <Product2> prods2Update = new List<Product2>();
        	 for(Product2 p : products){
                String pmain ='';
                 
                 for(Accessories__c a : accs){
                     if(p.id == a.Accessory_Product__c){
                         pmain  += a.Main_Product__r.Name+', ';
                     }
                    
                }
                 
                p.Main_Products__c	 = pmain;
                prods2Update.add(p);
             }
        update prods2Update;
    }
}