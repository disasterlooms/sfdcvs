public class queueAddSerialNumber implements Queueable {
    private List<finchLegacySerialNumbers__c> spiffs;
    public queueAddSerialNumber(List<finchLegacySerialNumbers__c> noSerial) {
        this.spiffs = noSerial;
    }
    public void execute(QueueableContext context) {
        
        List<Account> vs = [Select id, name from account where name = 'ViewSonic Corporation' limit 1];
        Set<String> pr = new Set<String>();
        Map<String,Product2> prod = new Map<String,Product2>();
        Set<String> legacy = new Set<String> ();
        for(finchLegacySerialNumbers__c f : spiffs){
            pr.add(f.Product__c);
            legacy.add(f.legacySpiffId__c);
        }
        /*
        
        for(Product2 p : [Select id, name from Product2 where name in : pr]){
            prod.put(p.name, p);
        }
       */
        
        Map<String,Spiff_Request__c> spiff = new Map<String,Spiff_Request__c>(); 
        for(Spiff_Request__c s : [Select id, Legacy_Spiff_Claim_Id__c  from Spiff_Request__c where Legacy_Spiff_Claim_Id__c  in: legacy ]){
            spiff.put(s.Legacy_Spiff_Claim_Id__c , s);
        } 
        
        
        List<Asset> newSerials = new List<Asset>();
        for( finchLegacySerialNumbers__c f : spiffs ){
            Spiff_Request__c s = new Spiff_Request__c ();           
            if(spiff.containsKey(f.legacySpiffId__c)){
                s = spiff.get(f.legacySpiffId__c);
            }
            
            
            Asset a = new Asset();
            a.TP__c = 'spiffLegacy';
            a.name = 'spiffLegacy';
            a.AccountId = vs[0].Id;
            a.serialnumber = f.SerialNumber__c;
            a.Product__c = f.Product__c;
            a.PurchaseDate = f.SaleDate__c;
            a.Spiff_Request__c = s.Id;
            newSerials.add(a);
		
        }

        insert newSerials;
        
    }
    
}