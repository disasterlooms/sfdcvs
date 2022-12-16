public class Dashboards {
    @AuraEnabled
    public static List<Wave_Dashboards__c> getOppLInes(String dgroup){
        User u = getUser.getUser();
        system.debug('user dsah '+u.Dashboard_Group__c);
        List<Wave_Dashboards__c> items = [SELECT Id, Name ,Dashboard_Id__c  FROM Wave_Dashboards__c
                                          where Dashboard_Group__c = : u.Dashboard_Group__c and IsActive__c = true
                                          order by Group_Order__c asc];
        system.debug('list products '+items );
        
        return items;
    }
}