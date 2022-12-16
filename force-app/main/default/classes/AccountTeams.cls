global class AccountTeams{
    
    // These variables store Trigger.oldMap and Trigger.newMap
    // 
    // test class is part of master trigger for account
    // 
    Map<Id, Account> oldAccts;
    Map<Id, Account> newAccts;
    
    List<Account> acctsToUpdate = new List<Account>();
    List<AccountTeamMember> aTeamToUpdate = new List<AccountTeamMember>();
    // This is the constructor
    // A map of the old and new records is expected as inputs
    public AccountTeams(
        Map<Id, Account> oldTriggerAccts, 
        Map<Id, Account> newTriggerAccts) {
            oldAccts = oldTriggerAccts;
            newAccts = newTriggerAccts;
        }
    
    // The one method your master trigger will call
    global void teams(List<Account> accounts) {
        /*
     * 
     * Commenting out this class as accout teams are set up using territory rules
     * and team class  
     * jason orbison 9.8.2021
     * 
     * 
        system.debug(oldAccts);
        //loop through the accounts that have been updated
        //and then remove all accounts that have same acct type, industry, and state
        //all the rest will update the account team
        
        List<Account> accountToUPdate = new List<Account>();
        List<Account> accountsToInsert = new List<Account>();
        
        system.debug('going through accounts to see what has been changed ');
        for(Account a : accounts){
            if(trigger.isUpdate){
                Account oa = oldAccts.get(a.Id);
                system.debug('old account '+ oa.Account_Type__c);
                if(oa.OwnerId != a.Ownerid || oa.Account_Type__c != a.Account_Type__c || oa.BillingState != a.BillingState || oa.Industry != a.Industry){
                    accountToUPdate.add(a);
                }  
            }else if(trigger.isInsert){
                accountsToInsert.add(a);
            }
        }
        //check if there are asny records in list
        if(accountToUPdate.size() > 0){
            AccountTeamAdd.teams(accountToUPdate);
        }else if(accountsToInsert.size() >0){
            AccountTeamAdd.teams(accountsToInsert);
        }
       */  
    }

}