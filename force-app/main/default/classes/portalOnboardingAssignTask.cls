global without sharing class portalOnboardingAssignTask {
    @AuraEnabled
    global static void assignTaks(String conId){
        Contact c = [select id , name,Account.name , VSSubRegion__c  ,accountId,mailingcountry,mailingstate
                     from contact where id =: conId];
                CountriesRegions__c cr = new CountriesRegions__c();
        try{
           cr = [SELECT Country__c,VSSubRegion__c FROM CountriesRegions__c
                                 where Country__c = : c.mailingcountry limit 1];  
        }catch(Exception e){
            
        }
        
         //adding field for unverified profile automatic tasks to automate tasks if the account
        //is a net new account based on business rules - user was not mapped to an account
        // state specific field denotes state or province is needed to add to field
        
        List< Portal_Task__c > tskStates =  [Select id, Type__c , Active__c  from Portal_Task__c
                                      where id in (Select Partner_Portal_Task__c
                                                      from Partner_Portal_Tasks_State__c where 
                                                      Country_State__r.State__c  =: c.mailingstate) and active__c = true];        
       
        
        List< Portal_Task__c > tsk = [Select id, Type__c , Active__c  from Portal_Task__c
                                      where required__c = true
                                      and (Country__c  = null or Country__r.Name =: c.mailingcountry )
                                      and (VS_Sub_Region__c   = null or VS_Sub_Region__c  =: cr.VSSubRegion__c  )
                                      and active__c = true];
        //if this is unverified partner account then add the list of 
        List<Contact> parentAccts = [Select id,AccountId,Account.Parent.Id,Account.Parent.Parent.Id from Contact
                                  where id = : conid];
        
        List<String> parentIds = new List<String>();
        for(Contact con : parentAccts){
            parentIds.add(con.AccountId);
            parentIds.add(con.Account.ParentId);
            parentIds.add(con.Account.Parent.ParentId);
        }
        
        /*Account a = [Select id, (Select id from contacts 
                                 where Portal_Status__c = 'Onboarded and Verified' and )
                     from Account where id != '0011H00002BdC3sQAF'
                     and id =: 
                     limit 1];      
          */
        
        List<Contact> portalContacts = [Select id from Contact
                                  where Portal_Status__c = 'Onboarded and Verified' and
                                    accountid in : parentIds and AccountId != '0011H00002BdC3sQAF'];
        
        if(portalContacts.size()>0){
           //if portal users already are onboarded for parent or child accounts and are not unverified
           //then do something here. The else will be portal users that we cannot find a certification
        }else{
             tsk.addAll(tskStates);
        }
        
        List<PortalOnboardingProgress__c > progress = new List<PortalOnboardingProgress__c>();
        
        for(Portal_Task__c p : tsk){
            PortalOnboardingProgress__c  pop = new PortalOnboardingProgress__c();
            pop.Portal_Account__c = c.AccountId;
            pop.Portal_Contact__c = c.Id;
            pop.Partner_Portal_Task__c = p.Id;
            pop.Status__c = 'Not Started';
            pop.Name = 'OnBoard '+c.Name +' '+c.Account.Name;
            //ensuring the string stays under the 80 requirement
            pop.Name = pop.Name.left(79);            
            progress.add(pop);
        }
        
        insert progress;
        
    }
    
}