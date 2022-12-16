public class OppPartnersMasterClass{
    Map<Id, Opportunity_Partner__c> oldOpps;
    Map<Id, Opportunity_Partner__c> newOpps;
    public OppPartnersMasterClass(
        Map<Id, Opportunity_Partner__c> oldTriggerOpps, 
        Map<Id, Opportunity_Partner__c> newTriggerOpps) {
            oldOpps = oldTriggerOpps;
            newOpps = newTriggerOpps;
        }
    
    public static void partnerCreatedBRCheck(List<Opportunity_Partner__c> records) {
        List<String> oppIds = new List<String>();
        for(Opportunity_Partner__c p : records){
        oppIds.add(p.Opportunity__c);
            
        }
        Map<String, Opportunity> oppsBRd = new Map<String,Opportunity>();
        for(Opportunity o : [Select id from opportunity where id in : oppIds and 
                            id in (Select opportunityId from Quote 
                                   where Spa_Request_Type__c = 'Bid Register Request'
                                   and BR_Resellers_OverRide__c  = false)]){
                                       oppsBRd.put(o.Id,o);
                                   }
        
        for(Opportunity_Partner__c p : records){
        //check if partner related to spa that is br'd
            if(oppsBrd.containsKey(p.opportunity__c)&& p.Partner_Type__c == 'Reseller / VAR'){
                //show error
                p.addError('There is a Bid Registered Spa. Only bid desk can add Resellers and must explicitly override this validation rule. '+
                                'This Message is from OppPartnersMasterClass and MasterOppPartnerTrigger.',false);
            }
            
        }
        
        
    }
    
    public void partnerChange() {
        
        //making sure the future class is only run on insert or delete of opportunity records
        //and only for resellers, not distributors. This will prevent the future to run when it is not needed.
        Set<Id> oppids = new Set<Id>();
        
        if(trigger.isInsert){
            for(Opportunity_Partner__c p : newOpps.values()){
                if(p.Partner_Type__c == 'Reseller / VAR'){
                    oppids.add(p.opportunity__c);                    
                }
                system.debug('size new opps '+newOpps.size());
            }
        }else if(trigger.isDelete){
            for(Opportunity_Partner__c p : oldOpps.values()){
                if(p.Partner_Type__c == 'Reseller / VAR'){
                    oppids.add(p.opportunity__c);                    
                }
                system.debug('size old opps '+oldOpps.size());
            }
        }
        
        if(oppids.size()>0){
            OppPartnersMasterClass.oppResellers(oppids);
        }
    }
    
    
    @future
    public static void oppResellers(Set<Id>oppids) { 
        //need to update the list of opportunity resellers on the field of opportunity
        //this is to have one long text field that can be filtered in Einstein analytics
        //by reseller.
        
        List<Opportunity> parts = [Select id,Resellers__c,Resellers_and_Type__c,Reseller_Names__c,( select id,opportunity__c,Partner_Type__c,partner_account__r.name
                                                                                                   from Opportunity_Partners__r where opportunity__c in: oppids and Partner_Type__c  = 'Reseller / VAR')
                                   from opportunity where id in : oppids for update];
        
        for(Opportunity o : parts){
            String partnames = '';
            String names = '';
            String res = '';
            
            for(Opportunity_Partner__c p : o.Opportunity_Partners__r){
                if(partnames == ''){
                    if(p.Partner_Type__c  == 'Reseller / VAR'){
                        res = p.partner_account__r.name;
                    }
                    
                    partnames = p.partner_account__c;
                    names =    p.partner_account__r.name;
                }else{
                    if(p.Partner_Type__c  == 'Reseller / VAR'){
                        res = res+'/'+p.partner_account__r.name;
                    }
                    partnames = partnames+'/'+p.partner_account__c;
                    names = names+'/'+p.partner_account__r.name;
                }
                
            }
            o.Resellers__c = partnames;
            o.Reseller_Names__c = names;
            o.Resellers_and_Type__c =  res.left(250);
        }
        try{update parts;}catch(Exception e){String t = 'Opportunity Reseller Names Update Error for id '+ parts[0].Id;AdminErrorMessage.SendError(e, t);}
    }
    
}