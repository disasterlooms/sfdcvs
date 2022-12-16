public class AccountStateOwners{
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Account> oldAccts;
    Map<Id, Account> newAccts;
    
    List<Account> acctsToUpdate = new List<Account>();
    List<Account> laacctsToUpdate = new List<Account>();
    
    
    public AccountStateOwners(
        Map<Id, Account> oldTriggerAccts, 
        Map<Id, Account> newTriggerAccts) {
            
            oldAccts = oldTriggerAccts;
            newAccts = newTriggerAccts;
        }
    
    // This is the constructor
    // A map of the old and new records is expected as inputs
    
    public static void acctUrlFuture(List<Account> records) {
        /*
Map<Id,User> us = new Map<Id,User>();

us.put(u.id, u);       
} 
User u = [Select id from user where isactive = true and userrole.name = 'System Administrator'
and usertype = 'standard'  limit 1];    
*/
        Set<Id> accs = new Set<Id>();
        Set<Id> resellers = new Set<Id>();
        
        for(Account a:records){
            accs.add(a.Id);
            if(a.Type != 'End User'){
                resellers.add(a.Id);           
            }
        }
        
        AccountStateOwners.acctUrlFutureStep2(accs);
        AccountStateOwners.acctResellerPartners(resellers);
        
    }
    
    public void  updateOwner() {
        //This class will run after update or after insert by queryying the Account user information
        //when user territory is added correctly it will get the account owner from the assigned 
        //territory rules. This happens after update or after insert, but after update only happens
        //when there is an update flag. 
        //
        //List< AccountUserTerritory2View>  own = new List <AccountUserTerritory2View>();
        List<Account> acctToUpdate = new List<Account>();              
        Set<String> records = new Set<String>(); 
        if(Trigger.isUpdate && TriggerContextUtility.isFirstRun()){
            for (Account a : newAccts.values()) {
                Account o  = oldAccts.get(a.Id);
                if(a.Ownerid != o.ownerid ||
                   a.BillingCountryCode != o.BillingCountryCode ||
                   a.billingStateCode != o.BillingStateCode || 
                   a.BillingCity != o.BillingCity ||
                   a.Industry != o.Industry ||
                   a.Type != o.Type ||
                   a.updateTerritoryandOwner__c == true){                       
                   a.updateTerritoryandOwner__c = false;
                   records.add(a.Id);
                   }
            } 
        }else if(Trigger.isInsert){
            for (Account a : newAccts.values()) {
                records.add(a.Id);
            }
            
        }
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        database.update(acctToUpdate, dml);
        
        if(!Test.isRunningTest() && TriggerContextUtility.istriggerQueable()){
         System.enqueueJob(new RunTerritoryRules(records));   
        }
        
        
        /*


Map<String,AccountUserTerritory2View> ownMap = new Map<String,AccountUserTerritory2View>();

for(AccountUserTerritory2View ot : [SELECT AccountId,Id,userid,RoleInTerritory2,Territory2Id 
FROM AccountUserTerritory2View where AccountId =: records[0].Id and RoleInTerritory2 = 'Account Owner']){
ownMap.put(ot.AccountId,ot);
}

List<Account> accToUpdate = new List<Account>();
Boolean runUpdate = false;
for(Account a:records){
if(ownMap.containsKey(a.Id)){
AccountUserTerritory2View av = ownMap.get(a.Id);
if(a.Ownerid != av.userid){
Account acct = new Account();
acct.Id = a.Id;
acct.Ownerid = av.userid;
accToUpdate.add(acct);
runUpdate = true;
}

}
}        
if(runUpdate){
database.update (accToUpdate[0],false);
}
*/
        
    }
    @future
    public static void acctResellerPartners(Set<Id> records) {
        List<Account> acc = [Select id, IsPartner,Type,mapConId__c ,Industry ,County__c , billingcountry,BillingState,billingStateCode,
                             Name,BillingCity,billingstreet,BillingPostalCode,owner.usertype ,ownerid from account where id in : records];
        List<AccountBrand> ab = new List<AccountBrand>();
        
        List<Contact> consToUpdate = new List<Contact>();
        User u = [Select id from user where isactive = true and userrole.name = 'System Administrator' limit 1];    
        Set<Id> conIds = new Set<Id> ();
        String ContactDocId = '';
        
        for(Account a : acc){
            if(a.BillingCountry == 'United States' || a.BillingCountry == 'Canada'){
                a.IsPartner = true;AccountBrand b = new AccountBrand(); b.CompanyName = a.Name;b.City = a.BillingCity;
                b.StateCode = a.billingStateCode;
                system.debug('Account brand');
                system.debug(a.billingStateCode);
                b.Country = a.BillingCountry;
                b.PostalCode = a.BillingPostalCode;
                b.Street = a.BillingStreet;
                b.name	= a.name;
                b.AccountId = a.Id;
                ab.add(b);
                system.debug('owner type '+ a.Owner.UserType);              
                
                
                //User use = us.get(a.ownerid);
                if(a.Owner.UserType != 'Standard' ){
                    a.Ownerid = u.Id; 
                }
                if(a.mapConId__c != null){
                    
                    Contact c = new Contact();c.Id = a.mapConId__c;conIds.add(c.Id);c.AccountId = a.Id;c.Portal_Status__c = 'Onboarded and Verified';consToUpdate.add(c); 
                    ContactDocId   =    a.mapConId__c;          
                    a.mapConId__c = null;     
                }
            }
            
        }
        
        system.debug('contact id '+ ContactDocId);
        
        Map<String,ContentDocumentLink> docMap = new Map<String,ContentDocumentLink>();
        for(ContentDocumentLink cdl : [Select id , linkedentityid, contentdocumentid,contentdocument.title
                                       from contentdocumentlink 
                                       where contentdocument.title like '%Reseller Certificat%' 
                                       and linkedentityid =: ContactDocId ]){
                                           docMap.put(cdl.linkedentityid, cdl);
                                       }
        
        system.debug('docum map ');
        system.debug(docMap);
        
        List<ContentDocumentLink> newLinks = new List<ContentDocumentLink>();
        Set<Id> acctLinks = new Set<Id>();
        
        List<Contact> consToLink = [Select id, accountid,Account.ParentID__c from contact where id in : consToUpdate ];
        
        for(Contact con : consToLink){
            system.debug('cons to update loop running');
            system.debug('con id '+ con.Id);
            if(docMap.containsKey(con.Id)){
                ContentDocumentLink doc = docMap.get(con.Id);
                
                ContentDocumentLink cd = new ContentDocumentLink();
                cd.ContentDocumentId = doc.ContentDocumentId;
                cd.LinkedEntityId = con.AccountId;
                cd.Visibility = 'AllUsers';
                newLinks.add(cd);
                acctLinks.add(con.AccountId);
                
                if(con.AccountId != con.Account.ParentID__c){
                    ContentDocumentLink cdp = new ContentDocumentLink();
                    cdp.ContentDocumentId = doc.ContentDocumentId;
                    cdp.LinkedEntityId = con.AccountId;
                    cdp.Visibility = 'AllUsers';
                    newLinks.add(cdp);
                    acctLinks.add(con.Account.ParentID__c);
                }
            }
        }
        
        system.debug(newLinks);
        system.debug('data for new link');
        
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        database.update(acc, dml);
        
        database.insert (ab,false);
        update consToUpdate;
        database.insert(newLinks, false);
        if(!system.isQueueable()){
           System.enqueueJob( new portalProfileUpdate(conIds));  
        }
        
        
        // notes on the process 3.22.2021 The above code and solution is based on the following:
        // 
        //  used database insert to ensure that other code is executed if document crud events error
        //  out, which is possible. Since this is a future class, getting notified of error and
        //  fixing an error, is a bit more challenging
        //  
        //   
        //    On the subject of getting reseller certificates, this code Links reseller
        //    certifications to the contact, account, and parent account. It does not link to 
        //    every contact in the organization because that is a larger process and unneccessary
        //    because reseller certifications will be searched on the account level, not the cotnact level
        //    and admins can find the certificate on the account and parent accounts. 
        //    
        //     the challenge will be legacy certificates. want to get the certificate with a linked id to the
        //     account or contact but that may not be avaialble. If unavailable, marketing admin or sales will 
        //     need to reach out to customer to get the reseller certificate. This is not as burdensome as it sounds
        //     because Credit deparment has the master list of Reseller certificates and will only ask when they do not
        //     have. It may become needed to send new certificates to credit after approval of the reseller certificate 
        //     document. will wait and see.  
        
    }
    
    
    @future
    public static void acctUrlFutureStep2(Set<Id> records) {
        
        List<Account> accts = [Select id,Education_Portal_URL__c from account where id in: records];
        
        CustomerKeys__mdt k = [SELECT key__c, SiteEducationSite__c  FROM CustomerKeys__mdt  limit 1];
        for(Account a : accts){
            if(a.Education_Portal_URL__c == '' || a.Education_Portal_URL__c == null) {
                system.debug(' blank portal field');
                encryptRecordId enc = new encryptRecordId();
                a.Education_Portal_URL__c = k.SiteEducationSite__c +enc.acctOwnerAssign(a.Id);   
            }
        }
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        database.update(accts, dml); 
        system.debug(accts);
        
        
    }
    
    public void acctDelete() {
        system.debug(oldAccts);
        
        for(Account a : oldAccts.values()){
            if(a.Focus_Account__c == true && 
               a.Type == 'End User'){
                   a.addError('You cannot delete or Merge a Focus Account. You must make the focus account the Master Id');
               }
        }
        
    }
    public void acctOwnerAssign(List<Account> records) {
        //Education_Portal_URL__c 
        
        //Only assigning the account the first record in collection
        //Because if uploading a list, we need to assign in csv or integration
        //not in the trigger as the code is not set for mapping 200 records
        //We do intend on updating code for larger collection sizes but need to
        //get this up and running right away.. 
        //
        // The idea is that the first record in collection is a user induced
        // account creation. This is not done on account update at the present but
        // may be updated down line. 
        
        String ownid = records[0].ownerid;
        AccountOwnerAssign assn = new AccountOwnerAssign();
        if(records[0].OwnerId != null){
            if(records[0].billingStateCode != ''&& records[0].billingStateCode != null){
                //ownid = assn.assignAcctOwner(records[0]);
                //records[0].OwnerId = ownid; 
            }
            
        }
        
        
        system.debug(records[0].OwnerId);
        
        
        
    }
    public void getPortalURL(List<Account> accts) {
        CustomerKeys__mdt k = [SELECT key__c, SiteEducationSite__c  FROM CustomerKeys__mdt  limit 1];
        for(Account a : accts){
            if(a.Education_Portal_URL__c == '' || a.Education_Portal_URL__c == null) {
                system.debug(' blank portal field');
                encryptRecordId enc = new encryptRecordId();
                a.Education_Portal_URL__c = k.SiteEducationSite__c +enc.acctOwnerAssign(a.Id);   
            }
        }
    }
    
    /*
public void lacountrytostate(List<Account> accts) {
id p = userinfo.getProfileId();

//create map using country and key and then map the state value
//and owners to the account records

for (Account  a : accts) {

if(a.BillingCountry == null &&  ((a.Type == 'VAR - Latin America' || p == '00e12000000bW39AAE'))){
//a.addError('You must have a Country for Latin America Account');
//removing this error now that country is a picklist 3/15.2021 jorbison
}else{

}
}
}
/// this method is not needed. Latin America only has states when country has states. 
//ownership managed through territory rules not through the Custom State Object 
*/
    
    public void checkstatesowners(List<Account> accts) {
        //create maps to get state information 
        //and map for county information
        
        
        //Select Userid,user.name from UserTerritory2Association 
        //where  RoleInTerritory2 = 'Account Owner' and Territory2Id in 
        //(Select Territory2Id from AccountUserTerritory2View  where Accountid = '001A000000tlSfNIAU')
        //Map<
        
        
        id p = userinfo.getProfileId();
        
        
        
        Set<String> city = new Set<String>();
        for(Account acc : accts){
            if(acc.BillingCity != null){
                city.add(acc.BillingCity.toLowerCase());
            }
        }
        
        Map<String, County__c> counties = new Map<String, County__c>();
        for (County__c c : [
            SELECT Name,Id,City__c,County__c,StateCode__c, State_Name_Full__c  FROM County__c
            WHERE City__c IN :city
        ]) 
            
            counties.put(c.City__c.toLowerCase()+ c.StateCode__c.toLowerCase() , c);
        
        system.debug('counties');
        system.debug(counties);
        
        for(Account a : accts){
            String statefield = '';
            system.debug('county state search '+a.billingStateCode);
            
            if(a.BillingCity != null && a.billingStateCode != null && counties.size() > 0 && counties.containsKey(a.BillingCity.toLowerCase()+a.billingStateCode.toLowerCase())){
                system.debug('all checked out');
                if(!a.Overwrite_County__c){
                    a.County__c = counties.get(a.BillingCity.toLowerCase()+a.billingStateCode.toLowerCase()).Name;
                }
                
                
                a.BillingCity = counties.get(a.BillingCity.toLowerCase()+a.billingStateCode.toLowerCase()).City__c;
                a.BillingCountry = 'United States';
            }
            system.debug('statefield');
            system.debug(statefield);
            
            
            // will create a new account with a city
            // this will test if the trigger is an update, it will 
            // only create an error if some one removed the city
            // it will allow the validation to pass if there was not a city
            // and then there is an update. this is for legacy accounts with bad data
            // to not cause errors that update on evaluation changes or opportunity changes 
            // where there are summary fields on the account from those objects that may trigger a change
            Account ac  = new Account(BillingCity='new acct',billingStateCode='CA');
            if(Trigger.isUpdate){
                ac = oldAccts.get(a.Id);
            }
            // system.debug(a.BillingCity.toLowerCase()+a.BillingState.toLowerCase());
            system.debug(counties);
            //get the metadata object and have this object link the correct fields for owners. this is to keep it eaiser to change ownership 
            //of accounts whenever business needs change
            //
            
            
            if(a.ParentId == null){
                a.HQ_Account_Check_if_HQ__c = true;
            }else{
                a.HQ_Account_Check_if_HQ__c = false;
            }
            
        }
        
        for(Account a : accts){
            a.DomainName__c = a.Domain__c;
        }
        
        
    }
}