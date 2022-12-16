public class getUser {
    @AuraEnabled
     public static User getUser()
    {     
         Id userId = UserInfo.getUserId();
        
         return [SELECT Name,Country,Dashboard_Group__c ,Sales_Category__c,Quota_Dashboard__c 
                 FROM User WHERE Id = :userId];
    }

}