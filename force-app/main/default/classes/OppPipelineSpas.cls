public with sharing class OppPipelineSpas {    
    @AuraEnabled
    public static List<Quote> getSpas(String recid,String ofields,String pfields)
    {     
        //create set of accounts to query the correct spas
        //account id can come from opportunity, contact, or account
        system.debug(' get spas method record id is '+recid);
        system.debug(' ofields '+ofields);
        system.debug(' pfields  '+pfields);
        
        Set<Id> recids = new Set<Id>();
        
        recids.add(recid);
        //Set<Id> oppids = new Set<Id>();        
        //Set<Id> consInOpp = new Set<ID>(); 
        
        String oppfields = String.escapeSingleQuotes(ofields);
        String prodfields = String.escapeSingleQuotes(pfields);
        
        system.debug(recid.substring(0,3)+' recid prefix');
        //get the acccount and parent account info from the opportunity
        //to search for similiar spas when getting from opportunity page
        
        //comment out. going to put the recid for any type of record in the set and then 
        //do a couple subqueries and merge the quieried records
        
        /*
        
        if(recid.substring(0,3) == '006'){
            Opportunity opp = [Select Id, AccountID,Account.ParentId from Opportunity where Id =:recid];
      
        //Limit the amount of Ids from the query before querying based account and parent accounts
            accounts.add(opp.AccountId);
            if(opp.Account.ParentId != null){
                accounts.add(opp.Account.ParentId); 
            }
            
           
        
        //go through the accounts and see if there any childern that should be added to results
        //since this may affect school districts and give too much data, we will exclude eduction
            List<Account> childAccs = [Select Id from account where ParentId in: accounts and Industry != 'Education'];
            for(Account a : childAccs){
                accounts.add(a.Id);
            }
            
        }else if(recid.substring(0,3) == '001'){
            Account acc = [Select Id, ParentId from Account where Id =:recid];
      
        //Limit the amount of Ids from the query before querying based account and parent accounts
            accounts.add(acc.Id);
            system.debug('parent id '+acc.ParentId);
            if(acc.ParentId != null){
                accounts.add(acc.ParentId);
            }
            
        
        //go through the accounts and see if there any childern that should be added to results
        //since this may affect school districts and give too much data, we will exclude eduction
        //
        //comment out since no longer looking at child accounts
            List<Account> childAccs = [Select Id from account where ParentId in: accounts and Industry != 'Education'];
            for(Account a : childAccs){
                accounts.add(a.Id);
            }
        }else if(recid.substring(0,3) == '003'){
            Contact con = [Select Id,AccountId,Account.ParentId from Contact where Id =:recid];
            //get the opportunities related to this contact
                       
            List<OpportunityContactRole> conopp = [Select OpportunityId from OpportunityContactRole where ContactId = : recid];
            
            List<Contact_Role__c> conopps = [Select Opportunity__c from Contact_Role__c where Contact__c = : recid];
            
            for(OpportunityContactRole op : conopp){
                 consInOpp.add(op.OpportunityId);
            } 
            
            for(Contact_Role__c opp : conopps){
                consInOpp.add(opp.Opportunity__c);
            } 
            
      
        //Limit the amount of Ids from the query before querying based account and parent accounts
            accounts.add(con.AccountId);
            if(con.Account.ParentId != null){
                accounts.add(con.Account.ParentId);
            }
           
        
        //go through the contacts and see if there any childern that should be added to results
        //since this may affect school districts and give too much data, we will exclude eduction
            List<Account> childAccs = [Select Id from account where ParentId in: accounts and Industry != 'Education'];
            for(Account a : childAccs){
                accounts.add(a.Id);
            }
        }
        //also need to query based on any link that was created with  the 
        //spa opp junction object
        
        //go through lists and get the parent account ids from all accounts so that we can
    	//go through query opp partners getting resellers and end users in results
    	List<Opportunity_Partner__c> partners = [Select  Opportunity__c from Opportunity_Partner__c where Account_Id__c in: accounts];
        for(Opportunity_Partner__c op : partners){
            oppids.add(op.opportunity__c);
        }
        */
        List<Quote> spasToReturn = Database.query('Select '+oppfields+',(Select '+prodfields+                                             
                      ' from QuoteLineItems) from Quote where Active__c = true and (AccountId in: recids or OpportunityId in: recids '+
                       ' )'+
                       ' order by ExpirationDate desc limit 25');
        
        List<Quote> spasPartners = Database.query('Select '+oppfields+',(Select '+prodfields+                                             
                      ' from QuoteLineItems) from Quote where Active__c = true and id in (select quote__c from opportunity_partner__c where partner_account__c in : recids) '+
                       ' order by ExpirationDate desc limit 25');
        
        List<Quote> spasOppAccounts = Database.query('Select '+oppfields+',(Select '+prodfields+                                             
                      ' from QuoteLineItems) from Quote where Active__c = true and AccountId in (select AccountId from Opportunity where Id in : recids) '+
                       ' order by ExpirationDate desc limit 25');
        
        List<Quote> spasOppContacts = Database.query('Select '+oppfields+',(Select '+prodfields+                                             
                      ' from QuoteLineItems) from Quote where Active__c = true and AccountId in (select AccountId from Contact where Id in : recids) '+
                       ' order by ExpirationDate desc limit 25');
        
        spasToReturn.addall(spasPartners);
        spasToReturn.addall(spasOppAccounts);
        spasToReturn.addall(spasOppContacts);
        
         List<Quote> spas = Database.query('Select '+oppfields+',(Select '+prodfields+                                             
                      ' from QuoteLineItems) from Quote where Active__c = true and Id in: spasToReturn '+
                       ' order by ExpirationDate desc limit 25');
        
        
        //add list to set and remove duplicates and then ret back to list to controller
        
        
        /*Set<Quote> spas = new Set<Quote>();
        spas.addAll(spasToReturn);

        system.debug(spas.size()+ ' set size');
        Integer indx = 0;
        List<Quote> retSpas = new List<Quote>();
        for(Quote s : spas){
            indx = indx+1;
            retSpas.add(s);
            system.debug(indx);
        }
        system.debug('get opps, the accounts found');
        system.debug(retSpas.size()+ ' list size');
		*/
        
        system.debug(spas.size()+' spa list size');
        return  spas;

    }

     @AuraEnabled
    public static Opportunity getOpp(String oppid)
    {    
        system.debug('the opp id is '+oppid);
        return [Select Id,Name,AccountId,Partner_Account_Search__c,Account.Name,
                ResellerContact__c,End_User_Contact__c,Trade_Show_or_Marketing_Campaign__c,
                CloseDate,Opportunity_Notes__c,Spa_ID__c, Pricebook2Id
                from Opportunity where id =:oppid limit 1];
    }
    @AuraEnabled
     public static User getUser()
    {     
         Id userId = UserInfo.getUserId();
        
         return [SELECT Name,Country FROM User WHERE Id = :userId];
    }
    

}