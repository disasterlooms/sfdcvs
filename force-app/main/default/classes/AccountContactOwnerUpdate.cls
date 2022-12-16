public class AccountContactOwnerUpdate {
    @future
    public static void UpdateOwners(Set<Id> cons,Set<Id> accts)
    {
        FutureContext.setFutureRan();
        
        Boolean a4 = FutureContext.futureHasRun();
        system.debug('before running has it ran '+a4 );
        
        List<Contact> conOwners = new List<Contact>();
        List<Account> accOwners = new List<Account>();
        //
        
        Set<Id> acctIds = new Set<Id>();
        
        system.debug('cons '+cons);
        
        if(accts.size() < 1){
            
            //this is an contact 
            //if the ownerid.profile name does not have sales then update the contact owner by
            //Account and or state rep
            conOwners = [Select Id, AccountId,Account.OwnerId,Account.Type,Owner.ProfileID,
                         Account.Owner.Profile.Name, OwnerId, Owner.Profile.Name,Account.Name,UserId__c, 
                         Account.Industry
                         from Contact where Id in: cons and Account.Non_Geo_Account__c = false];for(Contact c : conOwners){if(c.Account.Name == 'ViewSonic Corporation'){c.OwnerId = c.UserId__c;
                }else{if((c.Account.Type == 'VAR' || c.Account.Industry == 'Education' || c.Account.Industry == 'Education - Higher Education' )) {
                        acctIds.add(c.AccountId);}else if(c.Account.Type == 'End User'   && c.Account.Industry != 'Education' && c.Account.Industry != 'Education - Higher Education'){
                        acctIds.add(c.AccountId);}else if(c.Account.Type == 'VAR'){
                        acctIds.add(c.AccountId);}else{c.OwnerId = c.Account.OwnerId;}}}database.update(conOwners,false);
        }else{
            //this is an account
            //if the ownerid.profile name does not have sales then update the contact owner
            system.debug('okay, we got an account and are going to get the account info');
            accOwners = [Select Id, OwnerId,Type,Name,ParentId,BillingState,BillingCountry,Non_Geo_Account__c,
                         Owner.Profile.Name,Owner.ProfileID,Industry,BillingStreet,BillingCity,
                         ShippingStreet,ShippingCity,
                         ShippingState,ShippingPostalCode,BillingPostalCode,HQ_Account_Check_if_HQ__c,Channel__c,Owner.Accounting_Category__c,County__c
                         from Account where Id in: accts and Non_Geo_Account__c = false]; 
            
            accOwners = AccountContactOwnerUpdate.AccountAddress(accts);
            
            for(Account acc : accOwners){
                if(acc.Name == 'ViewSonic Corporation'){conOwners = [Select Id, UserId__c, OwnerId from Contact where AccountId =: acc.id];for(Contact c : conOwners){c.OwnerId = c.UserId__c;
                    }database.update(conOwners,false);
                }
                try{
                    update accOwners;}catch(Exception e){system.debug('error '+e);}
            }
        }
        accOwners = [Select Id, OwnerId,Type,Name,ParentId,BillingState,BillingCountry,Non_Geo_Account__c,
                     Owner.Profile.Name,Owner.ProfileID,Industry,BillingStreet,BillingCity,
                     ShippingStreet,ShippingCity,
                     ShippingState,ShippingPostalCode,BillingPostalCode,HQ_Account_Check_if_HQ__c,Channel__c,Owner.Accounting_Category__c,County__c
                     from Account where Id in: accts and Non_Geo_Account__c = true]; 
        
        accOwners = AccountContactOwnerUpdate.AccountAddress(accts);
        
        try{
            update accOwners;
        }catch(Exception e){
            system.debug('error '+e);
        }
    }
    public static List<Account> AccountAddress(Set<Id> accts)
    {
        
        system.debug('accounts and insert address');
        system.debug(accts);
        List<Account> accOwners = new List<Account>();
       
        
        accOwners = [Select Id, OwnerId,Type,Name,ParentId,BillingState,BillingCountry,Non_Geo_Account__c,
                     Owner.Profile.Name,Owner.ProfileID,Industry,BillingStreet,BillingCity,
                     ShippingStreet,ShippingCity,
                     ShippingState,ShippingPostalCode,BillingPostalCode,HQ_Account_Check_if_HQ__c,Channel__c,Owner.Accounting_Category__c,County__c
                     from Account where Id in: accts]; 
        
        system.debug('accowners list '+accOwners);
        
        Set<String> city = new Set<String>();
        for(Account acc : accOwners){
            if(acc.BillingCity != null){
                city.add(acc.BillingCity.toLowerCase());
            }
            
        }
        
        system.debug('set ');
        system.debug(city);
        
        Map<String, County__c> counties = new Map<String, County__c>();
        for (County__c c : [
            SELECT Name,Id,City__c,County__c, StateCode__c  FROM County__c
            WHERE City__c IN :city
        ]) 
            
            counties.put(c.City__c.toLowerCase()+ c.StateCode__c , c);
        
        system.debug('map ');
        system.debug(counties);
        for(Account a : accOwners){
            system.debug('the account cityand state ');
            system.debug(a.billingcity+a.billingstate);
            if(counties.size() > 0 && counties.containsKey(a.BillingCity.toLowerCase()+a.billingstate)){
                a.County__c = counties.get(a.billingcity.toLowerCase()+a.billingstate).Name;
                system.debug('there is a key');
                system.debug(counties.get(a.billingcity.toLowerCase()+a.billingstate).Name);
            }
            
            if(a.ShippingStreet == null){
                a.ShippingStreet = a.billingstreet;
                a.ShippingCity = a.billingcity;
                if(a.Owner.Accounting_Category__c !='Latin America'){
                    a.ShippingState = a.billingstate;
                }
                a.ShippingPostalCode = a.BillingPostalCode;
                a.ShippingCountry = a.BillingCountry;
            }
            if(a.ParentId == null){
                a.HQ_Account_Check_if_HQ__c = true;
            }else{
                a.HQ_Account_Check_if_HQ__c = false;
            }            
        }
        return accOwners;
    }
    
}