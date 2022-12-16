global class pp_schOnboardingTaks implements Schedulable {
    global void execute(SchedulableContext ctx) {
        
        List<Contact> cons = [Select id,pp_SendOnboardingAlert__c, (select id, sendAlert__c from Porta_lOnboarding_Progress__r
                                                                   where sendAlert__c = true
                              and Partner_Portal_Task__r.Required__c = false and Status__c  = 'Not Started' ) from Contact where id in 
                              (Select Portal_Contact__c  from PortalOnboardingProgress__c where sendAlert__c = true
                              and Partner_Portal_Task__r.Required__c = false and Status__c  = 'Not Started')];
        
        List<PortalOnboardingProgress__c> pptoUpdate = new List<PortalOnboardingProgress__c>();
        
        for(Contact c : cons){
            c.pp_SendOnboardingAlert__c = true;
            c.pp_SendOnboardingCnt__c = c.Porta_lOnboarding_Progress__r.size();
            for(PortalOnboardingProgress__c p : c.Porta_lOnboarding_Progress__r){
                p.sendAlert__c = false;
                pptoUpdate.add(p);                
            }
        }
        
        update cons;
        update pptoUpdate;
    }
    
}