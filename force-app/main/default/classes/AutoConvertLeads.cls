Public class AutoConvertLeads 
{     @InvocableMethod   
    public static void LeadAssign(List<Id> LeadIds)  
    {         
        Set<String> emails = new Set<String>();
        List<Lead> sers = [Select id, account__c,contact__c,email from lead 
                           where id in : leadIds];
        for(Lead l : sers){
            emails.add(l.email);
        }
        system.debug(emails);
        system.debug('emails');
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
        
        Map<String,Contact> cons = new Map<String,Contact>();
        for(Contact c : [Select id, accountId, email from contact where email in : emails ]){
            cons.put(c.email,c);
        }
        system.debug(cons);
        system.debug('check map');
        
        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
        for(Lead l : sers){
            if(cons.containsKey(l.email)){
                Contact c = cons.get(l.email);               
                
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(l.Id); 
                lc.setAccountId(c.AccountId);
                lc.setContactId(c.Id);
                lc.setConvertedStatus(CLeadStatus.MasterLabel);
                lc.setDoNotCreateOpportunity(TRUE); //Remove this line if you want to create an opportunity from Lead Conversion 
                MassLeadconvert.add(lc);
            }
            
        }
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        dml.optAllOrNone = false;
        
        if (!MassLeadconvert.isEmpty()) {
            List<Database.LeadConvertResult> lcr = Database.convertLead(MassLeadconvert,false);
        }
        
        
        
        //knfoaisnfei
    } 
}