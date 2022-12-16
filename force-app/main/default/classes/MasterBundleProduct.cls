public class MasterBundleProduct {    
    Map<Id, Package__c> oldPack;
    Map<Id, Package__c> newPack;
    
    public MasterBundleProduct(
        Map<Id, Package__c> oldTriggerPack,
        Map<Id, Package__c> newTriggerPack) {
            oldPack = oldTriggerPack;
            newPack = newTriggerPack;
        }
    public static  void updateParent(List<Package__c> records)
    {
        //after update,insert or delete, will query all the records
        //for each parent record that was changed and update a field
        //that summarizes all the data in the children
        //doing after insert or after delete so that the query of the parent 
        //record will accurately depict the most recent set of children records
        
        Set<String> parent = new Set<String>();
        for(Package__c p : records){
            parent.add(p.Product_Package__c);
            
        }
        
        String products = '';        
        List<Product_Package__c> pupdate = new List<Product_Package__c>();
        List<Product_Package__c> parentToUpdate = [Select Id, products__c,(Select Id,Product__r.name from Packages__r) from Product_Package__c where id in: parent];
        for(Product_Package__c pk :  parentToUpdate){
            products ='';
            for(Package__c p : pk.Packages__r){
                if(products == ''){
                    products = p.Product__r.name;
                }else{
                    products = products+'<br/>'+p.Product__r.name;
                }
            }
            pk.products__c = products;
            pupdate.add(pk);
        }
        
        update pupdate;
    } 
     public  void updateParentdel()
    {
        system.debug(oldPack);
        Set<String> parent = new Set<String>();
        for(Package__c p : oldPack.values()){
            parent.add(p.Product_Package__c);
            
        }
        
        String products = '';        
        List<Product_Package__c> pupdate = new List<Product_Package__c>();
        List<Product_Package__c> parentToUpdate = [Select Id, products__c,(Select Id,Product__r.name from Packages__r) from Product_Package__c where id in: parent];
        for(Product_Package__c pk :  parentToUpdate){
            products ='';
            for(Package__c p : pk.Packages__r){
                if(products == '' && !oldPack.containsKey(p.Id)){
                    products = p.Product__r.name;
                }else if(!oldPack.containsKey(p.Id)){
                    products = products+'<br/>'+p.Product__r.name;
                }
            }
            pk.products__c = products;
            pupdate.add(pk);
        }
        
        update pupdate;
    }
}