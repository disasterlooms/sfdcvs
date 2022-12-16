public class spiffpricing{
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, SpiffPricing__c> oldspiffs;
    Map<Id, SpiffPricing__c> newspiffs; 
    
    // A map of the old and new records is expected as inputs
    public spiffpricing(
        Map<Id, SpiffPricing__c> oldTriggernewspiffs, 
        Map<Id, SpiffPricing__c> newTriggernewspiffs) {
            oldspiffs = oldTriggernewspiffs;
            newspiffs = newTriggernewspiffs;
                    }
    
    public static void updatename(List<SpiffPricing__c> spiffs) {
        Map<String,pricebookentry> pbe = new Map<String,pricebookentry>();
        Set<String> products = new Set<String>();
         for(SpiffPricing__c st : spiffs){
                products.add(st.sku__c);
            }      
        
        
        List<pricebookentry> pbetoUpdate = new List<pricebookentry>();
        if(trigger.isInsert || trigger.isUpdate){
            for(pricebookentry p : [Select id, product2.name,name,pricebook2.name ,Disty_Spiff__c , Reseller_Spiff__c from pricebookentry where product2.name in: products])
            pbe.put(p.product2.name+ p.pricebook2.name, p);
            
            for(SpiffPricing__c s : spiffs){
                s.name = s.SKU__c+s.Price_Book__c;                
                if(s.SPG__c < 0 || s.SPG__c == null){
                    s.SPG__c = 0;
                }
                
                if(s.CDW__c < 0 || s.CDW__c == null){
                    s.CDW__c = 0;
                }
                
                if(s.NSP__c < 0 || s.NSP__c == null){
                    s.NSP__c = 0;
                }
                
                if(s.AV__c < 0 || s.AV__c == null){
                    s.AV__c = 0;
                }
                if(s.Distribution__c < 0 || s.Distribution__c == null){
                    s.Distribution__c = 0;
                }
                
                
                
                Double reseller = null;
                
                reseller = math.max(s.AV__c, s.CDW__c);
                reseller = math.max(reseller, s.NSP__c);
                reseller = math.max(reseller, s.SPG__c);
                system.debug('key: '+s.name);
                if(pbe.containsKey(s.name)){
                    system.debug('key found');
                    PricebookEntry e = pbe.get(s.name);
                    PricebookEntry entry = new PricebookEntry(id = e.Id,
                                                             Disty_Spiff__c = s.Distribution__c,
                                                             Reseller_Spiff__c = reseller);
                    pbetoUpdate.add(entry);
                    s.Pricebookentryid__c = e.Id;
                    
                }
            }
            
        }      
        
        
        
        system.debug('map');
        system.debug(pbe);
        update pbetoUpdate;
        system.debug('pbe to update list ');
        system.debug(pbetoUpdate);
        
    }
    
}