public without sharing class QuotaCQDays {
  public Decimal cqdays {get; set;}
    
    public void updatecs(){
    	List<SalesQuarter__c> sq = [SELECT Id, Name, SetupOwnerId, Days_In_CQ__c FROM SalesQuarter__c
                				where SetupOwnerId =: UserInfo.getOrganizationId()];
        sq[0].Days_In_CQ__c = cqdays;
        
        update sq[0];
  }
  
 public void updatedays(){
      List<SalesQuarter__c> sq = [SELECT Id, Name, SetupOwnerId, Days_In_CQ__c FROM SalesQuarter__c
                				where SetupOwnerId =: UserInfo.getOrganizationId()];     
     cqdays= sq[0].Days_In_CQ__c;
  }
     
   
}