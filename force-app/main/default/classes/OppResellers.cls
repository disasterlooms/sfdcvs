public class OppResellers {    
    @InvocableMethod(label='Get Reseller Names')
    public static void oppResellersget(List<Id>oppids) { 
        //need to update the list of opportunity resellers on the field of opportunity
        //this is to have one long text field that can be filtered in Einstein analytics
        //by reseller.
        
        Set<Id> opps = new Set<Id>();
        
        List <Opportunity_Partner__c> parts = [Select id,opportunity__c from Opportunity_Partner__c where
                                              id in : oppids];
        
        for(Opportunity_Partner__c p : parts){
            opps.add(p.opportunity__c);
        }
        
        OppResellers.oppaddResellers(opps);
        system.debug('invocable oppresellers ran');        
    }
    
    @future
    public static void oppaddResellers(Set<Id>oppsids) { 
        //need to update the list of opportunity resellers on the field of opportunity
        //this is to have one long text field that can be filtered in Einstein analytics
        //by reseller.
        
        List<Opportunity> parts = [Select id,Resellers__c,Resellers_and_Type__c,Reseller_Names__c,( select id,opportunity__c,Partner_Type__c,partner_account__r.name
                                                                                                   from Opportunity_Partners__r where opportunity__c in: oppsids and Partner_Type__c  = 'Reseller / VAR')
                                   from opportunity where id in : oppsids for update];
        
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
            system.debug('future reseller names '+parts);
        }
        try{update parts;}catch(Exception e){String t = 'Opportunity Reseller Names Update Error for id '+ parts[0].Id;AdminErrorMessage.SendError(e, t);Apex_Error_Message__c msg = new Apex_Error_Message__c ();msg.recordId__c = parts[0].Id;msg.ObjectType__c  = 'Opportunity Resellers Field';msg.Apex_Class__c = 'OppResellers';msg.UserId__c = UserInfo.getUserId(); msg.Error_Message__c = e.getmessage();database.insert(msg, false);}
    }

}