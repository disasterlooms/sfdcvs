public class getRegionInfo {
    public static  Map<String,CountriesRegions__c> getRegion() {
         Map<String,CountriesRegions__c> region = new  Map<String,CountriesRegions__c>();
            List<CountriesRegions__c> cr = [SELECT id,Available_StatesProvinces__c,CountryCode__c,Country__c,
                                            MapOwnerId__c,Name,VSRegion__c,
                                            StateCode__c,State__c,VSSubRegion__c FROM CountriesRegions__c];            
            for(CountriesRegions__c c : cr){
                region.put(c.CountryCode__c, c);
            } 
        return region;
            
        }
    
    public static List<Lead> getRegionLead(List<Lead> records){
        system.debug('Lead Regions running Country '+records.size());
        Map<String,CountriesRegions__c> region = getRegionInfo.getRegion();
        system.debug('map of region');
        system.debug(region);
        for(Lead l : records){
            system.debug(l.CountryCode);
            if(region.containsKey(l.CountryCode)){
                system.debug('Mapped coutnry found '+l.CountryCode);
                CountriesRegions__c c = region.get(l.CountryCode);
                l.VSRegion__c = c.VSRegion__c;
                l.VSSubRegion__c = c.VSSubRegion__c;
            }
        }
        
        return records;
    }
    
    public static List<Account> getRegionAccount(List<Account> records){
         system.debug(records);
        Map<String,CountriesRegions__c> region = getRegionInfo.getRegion();
        system.debug(region);
        for(Account l : records){
            system.debug(l.BillingCountryCode);
            if(region.containsKey(l.BillingCountryCode)){
                CountriesRegions__c c = region.get(l.BillingCountryCode);
                l.VSRegion__c = c.VSRegion__c;
                l.VSSubRegion__c = c.VSSubRegion__c;
            }
        }
        
        return records;
    }
    
    public static List<Contact> getRegionContact(List<Contact> records){
         system.debug(records);
        Map<String,CountriesRegions__c> region = getRegionInfo.getRegion();
        system.debug(region);
        for(Contact l : records){
            system.debug(l.MailingCountryCode);
            if(region.containsKey(l.MailingCountryCode)){
                CountriesRegions__c c = region.get(l.MailingCountryCode);
                l.VSRegion__c = c.VSRegion__c;
                l.VSSubRegion__c = c.VSSubRegion__c;
            }
        }
        
        return records;
    }
    
    public static List<User> getRegionUser(List<User> records){
         system.debug(records);
        Map<String,CountriesRegions__c> region = getRegionInfo.getRegion();
        system.debug(region);
        for(User l : records){
            system.debug(l.CountryCode);
            if(region.containsKey(l.CountryCode)){
                CountriesRegions__c c = region.get(l.CountryCode);
                l.region__c = c.VSRegion__c;
                l.VS_Sub_Region__c = c.VSSubRegion__c;
            }
        }
        
        return records;
    }
}