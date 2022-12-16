public class MasterAccessoriesClass {
    Map<Id, Accessories__c> oldAccs;
    Map<Id, Accessories__c> newAccs;
    
	public MasterAccessoriesClass(
        Map<Id, Accessories__c> oldTriggerAccs, 
        Map<Id, Accessories__c> newTriggerAccs) {
            oldAccs = oldTriggerAccs;
            newAccs = newTriggerAccs;
        }
    public static  void updateAcc(List<Accessories__c> records) { 
        //adding all main product id into a set to use for a query 
        //into products. 
        //this will then allow to update all products that have new accessorie
        //or deleted accessories
        Set<Id> mainprods = new Set<Id>();
        for(Accessories__c a : records){
            mainprods.add(a.Accessory_Product__c);
        }
        system.debug(mainprods);
        list<Product2> prods = [Select id,Main_Products__c,name, (Select Id,name,Accessory_Product__r.Name,Main_Product__r.name from Accessories1__r)
                               from product2 where id in: mainprods];
        String pacc = '';
        system.debug(prods[0]);
        for(Product2 p : prods){
             pacc = '';
            system.debug('size');
            system.debug(p.Accessories1__r.size());
            
            for(Accessories__c a : p.Accessories1__r){
                system.debug(a.name);
                pacc = pacc+a.Main_Product__r.Name+',';
            }
            p.Main_Products__c = pacc+p.name;
        }
        update prods;
    }
    public void updatedelAcc(){
        Set<Id> mainprods = new Set<Id>();
        
        for(Accessories__c a : oldAccs.values()){
            mainprods.add(a.Accessory_Product__c);
        }
        
        list<Product2> prods = [Select id,Main_Products__c,name, (Select Id,Accessory_Product__r.Name,Main_Product__r.name from Accessories1__r)
                               from product2 where id in: mainprods];
        String pacc = '';
        
        for(Product2 p : prods){
             pacc = '';
            for(Accessories__c a : p.Accessories1__r){
               
                pacc = pacc+a.Main_Product__r.Name+',';
            }
            p.Main_Products__c = pacc+p.name;
        }
        update prods;
        
    }
}