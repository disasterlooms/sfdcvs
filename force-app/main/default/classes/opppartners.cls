Public  class opppartners
{
    public Id opportunityId {get;set;}
    public Id pId {get;set;}
    public List<Opportunity_Partner__c> getopptys()
    {
        List<Opportunity_Partner__c> oppty;
        oppty = [SELECT Id, Partner_Account__c,Partner_Type__c,  Partner_Account__r.Name, Partner_Account__r.BillingCity,Partner_Account__r.BillingState,Contact_Name__c, Contact_Phone__c, Contact_Email__c FROM Opportunity_Partner__c WHERE Opportunity__c =: opportunityId And Partner_Type__c= 'Reseller / VAR'];
        return oppty;
    }
}