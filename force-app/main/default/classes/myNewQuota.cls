public class myNewQuota {
    
    @AuraEnabled
     public static List<User> getReps()
    {   
        List<User> myReps = [Select Id,Name,FirstName,LastName,
                             QuotaLabels__c ,QuotaFields__c 
                             from User where ManagerId =:UserInfo.getUserId() and isactive = true];
        
        return myReps;
    }
    @AuraEnabled
     public static User myFields()
    {   
        List<User> myReps = [Select id, QuotaLabels__c ,QuotaFields__c 
                             from User where Id =:UserInfo.getUserId()];
        
        return myReps[0];
    }
    @AuraEnabled
     public static List<SObject> createQuotas(List<SObject> quotas)
    { 
        system.debug(quotas);
        
        for(Sobject s : quotas){
            s.Id = null;
        }
        insert quotas;
        
        system.debug('created quotas');
        system.debug(quotas);
        return quotas;
        
    }

}