public without sharing class ContactUpdate{
    Map<Id, Contact> oldContacts;
    Map<Id, Contact> newContacts;
    
    public ContactUpdate(
        Map<Id, Contact> oldTriggerContacts,
        Map<Id, Contact> newTriggerContacts) {
            oldContacts = oldTriggerContacts;
            newContacts = newTriggerContacts;           
            
        }
    
    public  void UpdatePortalInfo(){
        Set<Id> conIds = new Set<Id>();
        Set<Id> deactivateIds = new Set<Id>();
        
        List<Account> a = [Select id,name from account where name = 'Partner Portal Unverified Contacts' limit 1];
        Id accId = null;
        if(a.size()>0){
            accId = a[0].Id;
        }
        for(Contact c : newContacts.values()){
            Contact old = oldContacts.get(c.Id);
            system.debug(c.portal_status__c+ ' portal status');
            if(c.Portal_Status__c  == 'Disqualified'){
                deactivateIds.add(c.Id);
                system.debug('disqualified contact');
            } 
        }
        
        //System.enqueueJob( new portalGroupVerified(conIds));  
        //lets make sure a batch or future is not source of trigger
        if (!System.isFuture() && !System.isBatch()){
            //ContactUpdate.updatePortalGroup(conIds);
            ContactUpdate.deactivateUser(deactivateIds);
            
        }
        
        
    }
    
    @future
    public static void deactivateUser(Set<Id> records) {
        
        List<User> us = [Select id, profileId, isactive from User where ContactId in : records];
        
        for(User u: us){
            u.isactive = false;
        }
       update us;
        
    }
        
    @future
    public static void updatePortalGroup(Set<Id> records) {
        
       
    }
        
       /* 
    @future
    public static void acctfinch(Set<Id> records) {
        
        List<Account> finches = [Select id, Finch_Club_Members__c , (Select Finch_Club_Status__c from Contacts ) from Account where id in : records];
        
         for(Account a : finches){
            Integer finch = 0;
             
            system.debug(finches);
            system.debug(finch);            
            for(Contact c : a.Contacts){
                if(c.Finch_Club_Status__c =='Active - Enrolled' ){
                    finch = finch +1;
                }
            }
             
             a.Finch_Club_Members__c = finch;
             system.debug('What the finch final '+finch);
        }
        
       update finches;

    }
   
    public void finches() {
        Set<Id> facct = new Set<Id>();
        
        Set<Id> facts = new Set<Id>();
        if(!trigger.isDelete){
            for(Contact c :  newContacts.values()){
                facts.add(c.AccountId);   
            }
        }else if(trigger.isDelete){
            for(Contact c :  oldContacts.values()){
                facts.add(c.AccountId);   
            }
            
        }
        
        ContactUpdate.acctfinch(facts);
        
                
    }
     */
    public static void custServ(List<Contact> records,Map<String,Account> acct)
    {
        Set<Id> ownerid = new Set<Id>();
        for(Contact con : records){
            ownerid.add(con.OwnerId);
        }
        
        Map<String, User> users = new Map<String, User>();
        for(User us : [Select Id, Email, LastName, FirstName, Phone from User where Id in: ownerid])
            users.put(us.Id , us);
        
        List<Campaign> camp = [Select Id from Campaign where name ='Customer Service Incoming Call' limit 1];
        
        //List <Contact> cons = [Select Id,Service_Rep__c, FirstName, AccountId,LastName, Email, OwnerId, Owner.Email,Log_Customer_Request__c,
        //Account.Name, Owner.FirstName,Phone from Contact where Id In: records];
        
        //List<Contact> consToUpdate = new List<Contact>();
        for (Contact c : records){
            // run if the log customer request if filled out...then unfill in case there is a new call
            //the adding of task is commented out on insert line because it should be done on the email message
            Account a = acct.get(c.AccountId);
            User u = users.get(c.OwnerId);
            if(c.Log_Customer_Request__c != null){
                
                Task t = new Task(WhoId= c.Id, WhatId = c.AccountId, ActivityDate= Date.Today(),
                                  Status='Completed',Subject= 'Customer called in, advised sales rep',
                                  Type = 'Call',Description= c.Log_Customer_Request__c,Campaign__c=camp[0].Id,
                                  OwnerId = UserInfo.getUserid(),IsVisibleInSelfService = true);
                
                insert t;
                // using apex for the email body so that we can 
                //have better tracking that the email was sent out 
                // and all reciepients. Email alerts not write to Email History Object
                //
                String body = '';
                body += u.FirstName+ ',<br/><br/>' ;
                body += 'Please contact your '+a.Type+' as they have contacted us and requested assistance. Here are the details:<br/><br/>';
                body += 'Account: '+a.Name +'<br/><br/>';
                body += 'Person: '+c.FirstName +' '+c.LastName +'<br/><br/>';
                body += 'Phone: '+c.Phone +'<br/><br/>';
                body += 'Email: '+c.Email +'<br/><br/>';
                body += 'Request: '+c.Log_Customer_Request__c +'<br/><br/><br/><br/> Template: None. Apex';
                system.debug(body);
                
                Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
                String[] to = new String[] {u.Email};            
                    String[] cc = new String[] {Label.AdminEmail};
                        mail.setToAddresses(to);
                mail.setSubject('Customer Requests Contact.Regarding a Purchase');
                mail.setHtmlBody(body);
                //mail.setCcAddresses(cc);   
                mail.setSaveAsActivity(true);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
                c.Log_Customer_Request__c = null;
                
                CampaignMember cm = new CampaignMember(CampaignId= camp[0].Id,
                                                       ContactId=c.Id,
                                                       Status='Sent'
                                                      );
                system.debug('log cust req '+cm);
                try{
                    insert cm;   
                }catch(Exception e){
                    //the error is because the member already exists, no email
                    //to admin
                }                
            }
        }
        // deprecated finch club 9.12.2021 jason orbison ContactUpdate.AddFinchClub(records,acct);
    }
    
    public static void UpdateOwner(List<Contact> contacts){
        
        //create 2 maps. one for account and the other for state 
        //to determine correct contact ownership
        //Since this is an before update, maps used to update related records
        
        Set<Id> acctid = new Set<ID>();
        for(Contact con: contacts){
            acctid.add(con.AccountId);
        }
        
        id p = userinfo.getProfileId();        
        
        Map<String, Account> acct = new Map<String, Account>();
        for(Account a : [Select id,ownerid, Type,BillingStreet,BillingCity,BillingPostalCode,
                         BillingCountry,Owner.ProfileId,Owner.Profile.Name,
                         Name,BillingState,Industry from Account where id in: acctid])
            acct.put(a.Id , a);
        
       
        
        String t = '';
        for(Contact c : contacts){
            if(acct.containsKey(c.AccountId)){                
                Account a = acct.get(c.AccountId);
                //if unverified account, then we don't want to map the account owner, we want to
                //map to correct owner based on Geo
                //
                //Yes, this is a literal name, but okay because all processes will be the same for this account that has a single use. 
                if(a.Name != 'Partner Portal Unverified Contacts'){
                   c.OwnerId = a.OwnerId; 
                }
                
                if(c.mailingstreet == null){
                    c.mailingstreet = a.Billingstreet;
                }
                if(c.mailingstreet == null){
                    c.mailingcity = a.BillingCity;
                }
                if(c.mailingstreet == null){
                    c.mailingstate = a.BillingState;
                }
                if(c.mailingstreet == null){
                    c.MailingPostalCode = a.billingpostalcode;
                }
                if(c.mailingstreet == null){
                    c.MailingPostalCode = a.billingpostalcode;
                    c.mailingcountry = a.billingcountry;
                }
                if(c.Same_Address_As_Account__c == true){
                    c.mailingstreet = a.Billingstreet;
                    c.mailingcity = a.BillingCity;
                    c.mailingstate = a.BillingState;
                    c.MailingPostalCode = a.billingpostalcode;
                    c.mailingcountry = a.billingcountry;
                    c.Same_Address_As_Account__c = false;
                }
                /** jason orbison commenting out the billing country code since it now is 
                 // completed by picklist values
                 // and validation rules 8.6.2021
                 // 
                if((a.billingcountry != 'United States' && a.billingcountry != 'Canada' && a.BillingCountry != null) ||  a.Type == 'VAR - Latin America' || p == '00e12000000bW39AAE'){
                    //do nothing Latin America may not have a state and it is not required
                }else if(a.BillingState == null){
                    c.addError('The Account does not have a valid State and/or Country. Please update account state (US and Canada) or billing Country (if Latin America)before creating this contact');
                    
                }
                */
            }else{
                c.addError('Contacts must Have an Account. Please Add an Account.');
            }            
        }
        
        try{
            ContactUpdate.custServ(contacts,acct);
        }catch(Exception e){
            //not sending the error message. The error happens when there is no person to assign the contact
            //to because the account type is not geo based
            //
            t = ' error in adding owner for contact ';
            AdminErrorMessage.SendError(e, t);
        }
        
        
    }
    
    /* deprecated 9.13.2021 jason orbison finch club is replaced with
          * partner program and this campaign is no longer needed
          * 
          *
    
    public static void AddFinchClub(List<Contact> records,Map<String,Account> acct){
        //get the finch club campaign name
        //and then loop through the contacts from the insert or update trigger
        //this will add contacts to campaigns if they are finch enrolled
        
         
        system.debug( 'finch start ');
        
        List<Campaign> camp = [Select Id from Campaign where name ='Finch Club Members' limit 1];
        //make sure there is a campaign named finch club
        system.debug('query camp '+camp);
        
        if(camp.size()>0){
            //create a string of contacts already in list to ensuer
            //the contact is not already on the list
            Map<String, CampaignMember> members = new Map<String,CampaignMember>();
            for (CampaignMember con : [
                SELECT Id, ContactId FROM CampaignMember
                WHERE Campaign.Name = 'Finch Club Members'])
                members.put(con.ContactId, con);
            
            List <CampaignMember> cm = new List <CampaignMember>();
            
            for (Contact c : records){
                // If check if this is a finch club member if so
                
                //add to the campaign finch club
                
               
                system.debug('finch status '+c.Finch_Club_Status__c+' LastName '+c.LastName);
                
                if(c.Finch_Club_Status__c == 'Active - Enrolled' && (!members.containsKey(c.Id))){
                    CampaignMember campm = new CampaignMember(CampaignId= camp[0].Id,
                                                              ContactId=c.Id,
                                                              Status='Sent'
                                                             );
                    cm.add(campm); 
                }
                    
            }
            
            try{
                insert cm;
            }catch(Exception e){
                String t = 'Contact Finch Club ';
                AdminErrorMessage.SendError(e,t);
            }  
        }
       
    } 
    */
    
    
    /*
    public static void ContactMailingAddress(List<Contact> records){
        List<Contact> consToUpdate = new List<Contact> ();
        for(Contact c: [Select Id, AccountId, Account.BillingStreet,Account.BillingCity,Account.BillingCountry,
                        Account.BillingState, Account.BillingPostalCode,Same_Address_As_Account__c,
                        mailingstreet,mailingcity,mailingstate, mailingpostalcode,mailingcountry
                        from Contact where Id In: records]){
                            if(c.Same_Address_As_Account__c == true){
                                c.mailingstreet = c.account.Billingstreet;
                                c.mailingcity = c.account.BillingCity;
                                c.mailingstate = c.account.BillingState;
                                c.MailingPostalCode = c.account.billingpostalcode;
                                c.mailingcountry = c.account.billingcountry;
                                c.Same_Address_As_Account__c = false;
                                consToUpdate.add(c);
                            }
                        }
        database.update(consToUpdate, false);
    }
*/
}