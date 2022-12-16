public class posAliasApp {
     @AuraEnabled
    public static List<POSAccountAliases__c> getAliases(String aname){
        
        List<POSAccountAliases__c> alias = [Select id, name, channel__c, Reseller_Alias__c ,End_User_Alias__c,DistributorAlias__c,SFDC_Account__c,SFDC_Account__r.Name,
                                            SFDC_Account__r.Owner.Name from POSAccountAliases__c
                                           where Reseller_Alias__c = : aname or name = : aname or End_User_Alias__c = : aname or DistributorAlias__c = : aname];
        
        return alias;
        
    }

}