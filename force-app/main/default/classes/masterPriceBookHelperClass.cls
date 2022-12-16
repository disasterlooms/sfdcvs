public class masterPriceBookHelperClass{
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Pricebook2> oldBooks;
    Map<Id, Pricebook2> newBooks; 
    
    // This is the constructor
    // A map of the old and new records is expected as inputs
    public masterPriceBookHelperClass(
        Map<Id, Pricebook2> oldTriggerBooks, 
        Map<Id, Pricebook2> newTriggerBooks) {
            oldBooks = oldTriggerBooks;
            newBooks = newTriggerBooks;
        }
    
    
    public static void newproduct(List<Pricebook2> records) {
        //9.29 jason.orbison
        //this code creates a new standard prie book if a new currency is used fro 
        //a new pricebook
        //
        //it will check if the curerency exists in the priceb ook and if new 
        //currency, it will add products and prices in standard
        //it also ensures that an active currency iso code is given for pricebook
        List<String> curc = new List<String>();
        
        for(Pricebook2 p : records){
            if(p.CurrencyIsoCode__c == null){
                p.addError('You must have an active currency ISO for Pricebook');              
                
            }else{
                curc.add(p.CurrencyIsoCode__c);
            }
        }
        Map<String,CurrencyType> curMap = new Map<String,CurrencyType>();
        for(CurrencyType c : [SELECT Id,IsActive,IsoCode FROM CurrencyType where isactive = true])
            curMap.put(c.IsoCode, c);
        
        List<PriceBookEntry> entries = new List<PriceBookEntry>();
        if(test.isRunningTest()){
            entries = [Select id, pricebook2Id, product2Id,CurrencyIsoCode from PriceBookEntry 
                       where pricebook2Id = : test.getStandardPricebookId() and product2.isactive = true ];
        }else{
            entries = [Select id, pricebook2Id, product2Id,CurrencyIsoCode from PriceBookEntry 
                       where pricebook2Id in (Select id from Pricebook2 where name like 'standard%') and product2.isactive = true ];
        }
        
        Map<String,PriceBookEntry> pbIso = new Map<String,PriceBookEntry>();
        Map<String,Pricebookentry> newEntriesMap = new Map <String,Pricebookentry>();
        for(PriceBookEntry et : Entries){
            pbIso.put(et.CurrencyIsoCode,et);
            newEntriesMap.put(et.Product2Id,et);
        }
       
        Map<String,Pricebook2> isoMap = new Map <String,Pricebook2>();
        
        for(Pricebook2 p : records){
            if(!curMap.containsKey(p.CurrencyIsoCode__c)){
                p.addError('You must have an active currency ISO for Pricebook');            
                
            }else{
                system.debug('iso is good');
                if(!pbIso.containsKey(p.CurrencyIsoCode__c)){
                    isoMap.put(p.CurrencyIsoCode__c,p);
                    system.debug('add iso to map '+ isoMap);
                    
                    
                }
            }
        }    
        system.debug('entries');
        system.debug(entries);
        system.debug('newEntriesMap');
        system.debug(newEntriesMap);
        
        system.debug('isoMap');
        system.debug(isoMap);
        List<Pricebookentry> newEntriesInsert = new List<Pricebookentry>();
        
        for(Pricebookentry pb : newEntriesMap.values()){
            
            for(Pricebook2 p : isoMap.values()){
                
                PricebookEntry entry = new PricebookEntry();
                entry.unitprice = 9999999;
                entry.pricebook2Id = pb.pricebook2Id;
                entry.product2Id = pb.product2Id;
                entry.isactive = true;
                entry.CurrencyIsoCode = p.CurrencyIsoCode__c;
                newEntriesInsert.add(entry);
            }           
            
        }
        system.debug('entries insert');
        system.debug(newEntriesInsert);
		insert newEntriesInsert; 
        
        
    }
    
    
}