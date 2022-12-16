global class schAccountTeam implements Schedulable {
  global void execute(SchedulableContext ctx) {
      List<Account> accts = [SELECT ID,Acct_Team_Check__c from Account where Acct_Team_Check__c = true limit 9999];
      List<AccountTeamMember> teamToDelete = [Select Id from AccountTeamMember where Accountid in : accts];
      List<AccountTeamMember> aTeamToUpdate = new List<AccountTeamMember>();
      database.delete(teamToDelete,false);
      
      for (Account  a : [SELECT Type,Id,ParentId,Name,BillingState,BillingCountry,BillingStreet,BillingCity,Acct_Team_Check__c,
                           ShippingStreet,OwnerId,ShippingCity,ShippingState,ShippingPostalCode,BillingPostalCode,
                           ShippingCountry,HQ_Account_Check_if_HQ__c, Owner.ManagerId ,Industry,
                           Channel__c FROM Account WHERE Id IN :accts]) {
                               a.Acct_Team_Check__c = false;
                               
        	
    	}
      database.insert(aTeamToUPdate, false);
      for(Account ac : accts){
          ac.Acct_Team_Check__c = false;
      }
      database.update(accts, false);
    }
  }