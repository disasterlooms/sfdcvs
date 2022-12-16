public class OppPipelineFollowUp {
     @AuraEnabled
    public static List<Contact_Role__c> getOppContacts(List<Opportunity> opps)
    {     
        system.debug(opps);
        
        return [Select Id,Opportunity__r.Name,Contact__r.Name,Opportunity__r.Account.Name,Contact__r.Email,Send_Follow_Up_Email__c,
                Role__c,Contact_Name__c,Email__c,End_User_Account__c,Contact__r.Account.Name from Contact_Role__c where Opportunity__c in: opps order by Opportunity__r.Name];
    }
    @AuraEnabled
    public static List<Contact_Role__c> emailCons(List<Contact_Role__c> oppcons)
    {     
        List<Contact_Role__c> selectedCons =  [Select Id,Send_Follow_Up_Email__c from Contact_Role__c 
                                             where id in: oppcons];        
        
        List<Contact_Role__c> consToUpdate =  new List<Contact_Role__c>();
            
        system.debug('cons to email'+oppcons);
        
        for(Contact_Role__c c: selectedCons){
            c.Send_Follow_Up_Email__c = true;
                consToUpdate.add(c);
        }
        update consToUpdate;
        system.debug(consToUpdate);
        return oppcons;
    }
    

}