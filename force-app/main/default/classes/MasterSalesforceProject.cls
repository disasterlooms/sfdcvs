public class MasterSalesforceProject{
    Map<Id, SalesforceProject__c> oldProj;
    Map<Id, SalesforceProject__c> newProj;
    
    public MasterSalesforceProject(
        Map<Id, SalesforceProject__c> oldTriggerProj, 
        Map<Id, SalesforceProject__c> newTriggerProj) {
            oldProj = oldTriggerProj;
            newProj = newTriggerProj;
        }
    public  void projpriority() {
        
        Decimal newpriorities = 10000;
        Decimal oldpriorities = 10000;
        String projid = '';
        system.debug(newProj);    
        
        if(newProj.size() == 1){ 
            if(Trigger.isUpdate){
                for(SalesforceProject__c p : oldProj.values()){
                    oldpriorities = p.priority__c;
                }
            } 
            for(SalesforceProject__c p : newProj.values()){
                newpriorities = p.priority__c;
                projid = p.Id;
            }
            system.debug('update old then new');    
            system.debug(oldProj);
            system.debug(newProj);
            
            List<SalesforceProject__c> projs = [Select id , priority__c from SalesforceProject__c 
                                                where priority__c >= : newpriorities
                                                and priority__c < : oldpriorities and id != : projid
                                                and (Status__c = 'Planned' or
                                                     Status__c = 'In Progress')];
            system.debug(projs);
            for(SalesforceProject__c p : projs){
                p.Priority__c = p.Priority__c +1;
            }
            update projs;
        }
    }        
}