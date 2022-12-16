global class AccountOwners{
  @future
  public static void UpdateOwners(String jsonString) {
     
      
      /*
       *  List<State__c> states = (List<State__c>)Json.deserialize(jsonString,List<State__c>.class);

       List<Account> tmaccs = [Select id, Name, State__c,OwnerId,Account_Type__c,Industry,Owner.Sales_Category__c 
                                from Account where State__c In: states AND 
                                Owner.Sales_Category__c != 'AV Solutions' AND (Account_Type__c = 'VAR' or Industry='Education') ];

        List<Account> rbmaccs = [Select id, Name, State__c,OwnerId,Account_Type__c,Industry,Owner.Sales_Category__c 
                                from Account where State__c In: states AND Owner.Sales_Category__c != 'AV Solutions'
                                 AND Account_Type__c like 'End User' AND Industry != 'Education'];

        List<Account> tmaccountsToUpdate = new List<Account>();
        List<Account> rbmaccountsToUpdate = new List<Account>();
         
        List<AccountTeamMember> insertacctteams = new List<AccountTeamMember>();
        
        for(State__c s: states ){
        
            for(Account a : tmaccs){
                a.OwnerId = s.Territory_Manager__c;
                tmaccountsToUpdate.add(a);
                    
                    AccountTeamMember at= new AccountTeamMember(AccountId = a.Id,  
                                                    TeamMemberRole='TM',
                                                    AccountAccessLevel='Edit',
                                                    CaseAccessLevel='Edit',
                                                    ContactAccessLevel ='Edit',
                                                    OpportunityAccessLevel='Edit',
                                                    userid=s.Territory_Manager__c);
                   insertacctteams.add(at);
                
                }
                
                for(Account acc : rbmaccs ){
                    acc.OwnerId = s.RBM__c;
                    rbmaccountsToUpdate.add(acc);
                    
                        AccountTeamMember at= new AccountTeamMember(AccountId = acc.Id,  
                                                    TeamMemberRole='TM',
                                                    AccountAccessLevel='Edit',
                                                    CaseAccessLevel='Edit',
                                                    ContactAccessLevel ='Edit',
                                                    OpportunityAccessLevel='Edit',
                                                    userid=s.Territory_Manager__c);
                       insertacctteams.add(at);
                
                } 
        
        }
        
        system.debug('rbm '+tmaccountsToUpdate);
        system.debug('tm '+tmaccountsToUpdate);
        system.debug('accteam '+tmaccountsToUpdate);
        
        update tmaccountsToUpdate;
        update rbmaccountsToUpdate;
        insert insertacctteams;


 */

    
    
  }  
}