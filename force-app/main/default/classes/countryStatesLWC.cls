public without sharing class countryStatesLWC {
    @AuraEnabled(cacheable=true)
    public static List<Address__c> getBillingAddresses(String evalId) {
        Eval_Request__c eval = [Select id, Shipping_Contact_Name__r.AccountId,
        Billing_Contact_Name__r.AccountId , Shipping_Contact_Name__c, Billing_Contact_Name__c,
        Reseller_Contact_Name__c,Reseller_Contact_Name__r.AccountId from eval_request__c where id =: evalId
         limit 1];

        
        Map<String,Address__c> bAddressMap = new Map<String,Address__c>();
        /*
        List<Account> add = [Select id, Name,billingStreet,BillingCity,BillingStateCode,
        BillingCountryCode,billingpostalcode from account where id = : eval.Reseller_Contact_Name__r.Id
        or id = : eval.Reseller_Contact_Name__r.AccountId or id = : eval.Shipping_Contact_Name__r.AccountId
        or id = : eval.Billing_Contact_Name__r.AccountId];
        */

        List<Contact> conAdd = [Select Name,Account.Name ,mailingstreet,mailingcity,mailingstatecode,mailingcountrycode,
        mailingpostalcode,Account.BillingStreet, Account.BillingCity,Account.BillingStateCode,
        Account.BillingCountryCode, account.billingpostalcode        
        from Contact where id =: eval.Reseller_Contact_Name__c or 
        id =: eval.Shipping_Contact_Name__c or
        id =: eval.Billing_Contact_Name__c  or
        id =: eval.Reseller_Contact_Name__c];
        
        for(Contact ac : conAdd){
            Address__c ad = new Address__c();
            system.debug(ac.MailingStreet);            
            ad.Company__c = ac.Account.Name;
            ad.Contact_Name__c = ac.Name;            
            ad.Street__c = ac.MailingStreet;
            ad.city__c = ac.Mailingcity;
            ad.State_Province__c = ac.Mailingstatecode;
            ad.country__c = ac.Mailingcountrycode; 
            ad.postal_code__c = ac.Mailingpostalcode;
            ad.fullAddress__c = ac.Account.Name+' '+ac.Name+' '+ ac.MailingStreet+ ' '+
            ac.Mailingcity+ ' '+
            ac.Mailingstatecode+ ', '+
            ac.Mailingcountrycode+ ' '+
            ac.Mailingpostalcode+ ' ';
            bAddressMap.put(ac.MailingStreet, ad); 
            
            Address__c adb = new Address__c();
            system.debug(ac.MailingStreet);            
            adb.Company__c = ac.Account.Name;
            adb.Contact_Name__c = ac.Name;            
            adb.Street__c = ac.Account.BillingStreet;
            adb.city__c = ac.Account.Billingcity;
            adb.State_Province__c = ac.Account.Billingstatecode;
            adb.country__c = ac.Account.Billingcountrycode; 
            adb.postal_code__c = ac.Account.Billingpostalcode;
            adb.fullAddress__c = ac.Account.Name+' '+ac.Name+' '+ ac.Account.BillingStreet+ ' '+
            ac.Account.Billingcity+ ' '+
            ac.Account.Billingstatecode+ ', '+
            ac.Account.Billingcountrycode+ ' '+
            ac.Account.Billingpostalcode+ ' ';
            bAddressMap.put(ac.Account.BillingStreet, adb); 
            
        }

        List<Address__c> bAddress = new List<Address__c>(bAddressMap.values());
        system.debug('address list data');
        //adding an index to get values in javascript
        for (Integer i = 0; i < baddress.size(); i++) {
            baddress[i].externalId__c = string.valueOf(i);
        }

        return bAddress;


    }
    
    @AuraEnabled(cacheable=true)
    public static List<CountriesRegions__c> getCountries() {
        List<CountriesRegions__c> CR =  [Select id, Country__c,CountryCode__c,State__c,StateCode__c
        from CountriesRegions__c order by Country__c];
         
        Map<String,CountriesRegions__c> crMap = new Map<String,CountriesRegions__c>();
        for(CountriesRegions__c c : cr){
         crMap.put(c.CountryCode__c,c);
        }
        List<CountriesRegions__c> countries = new List<CountriesRegions__c>();
        for(CountriesRegions__c cM : crMap.values()){
            countries.add(cM);
        }
                system.debug('Country State Map Results');
                system.debug(countries);
            return countries;
        }
     @AuraEnabled(cacheable=true)
    public static List<CountriesRegions__c> getStates() {
        Map<String,List<String>> statesNO = new Map<String,List<String>>();
        List<CountriesRegions__c> states = [Select id, Country__c, CountryCode__c ,State__c,StateCode__c
        from CountriesRegions__c where StateCode__c != null order by State__c];
       system.debug('get states running ');
            return states;
        }

    @AuraEnabled(cacheable=true)
    public static List<Address__c> getAddresses(String persId) {      
        system.debug('string person '+persId );

        List<Address__c> addrToStart = [Select id, street__c, city__c,State_Province__c,
        country__c, postal_code__c ,fullAddress__c from Address__c where contact__c =: persId];
        
        List<Account> acc = [Select id, billingstreet, billingcity,billingstatecode,
        billingcountrycode,billingpostalcode from Account where id in (Select accountid 
        from contact where id =: persId) limit 1];
        Map<String,Address__c> bAddressMap = new Map<String,Address__c>();

        for(Account ac : acc){
            Address__c ad = new Address__c();
            system.debug(ac.BillingStreet);            
            ad.Street__c = ac.BillingStreet;
            ad.city__c = ac.billingcity;
            ad.State_Province__c = ac.billingstatecode;
            ad.country__c = ac.billingcountrycode; 
            ad.postal_code__c = ac.billingpostalcode;
            ad.fullAddress__c = ac.BillingStreet+ ''+
            ac.billingcity+ ' '+
            ac.billingstatecode+ ', '+
            ac.billingcountrycode+ ' '+
            ac.billingpostalcode+ ' ';
            bAddressMap.put(ad.Street__c,ad);
        }
        for(Address__c a : addrToStart){
            a.fullAddress__c = a.street__c+' '+
            a.City__c+' '+
            a.State_Province__c+', '+
            a.country__c+' '+
            a.postal_code__c+' ';            
            bAddressMap.put(a.Street__c,a);
        }
        List<Address__c> addr = new List<Address__c>(bAddressMap.values());
        for (Integer i = 0; i < addr.size(); i++) {
            addr[i].externalId__c = string.valueOf(i);
        }
        system.debug('addresses ');
        system.debug(addr);

            return addr;
        }
        
    }