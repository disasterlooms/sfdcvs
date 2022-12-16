global class massLeadConvert implements 
Database.Batchable<sObject>, Database.Stateful {
    
    // Assuming we can get the account Id mapped to leads that should be contacts because the account has been qualified
    // this batch process can be ran in executable anyomous mode but should be in batches of 25  e.g. Database.executeBatch(massLeadConvert, 25);
    // This ensures there are less errors on some of the campaign matching class on the contact trigger master class until that class is updated for bulkifiability.. yes made up a word.
    // This is for only US and Canada for now. As we go global, may want to use metadata or object custom records to modify the query instead of updating the code below
    // 
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {        
        return Database.getQueryLocator(
            'Select id, account__c,contact__c from lead where account__c != null and country in (\'United States\',\'US\',\'U.S.\',\'Canada\') and isconverted = false and (not name like \'%unknown%\')  and email != null and EmailBouncedDate = null'
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> sers){
        //
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];

        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
            for(Lead l : sers){
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(l.Id);                
                lc.setAccountId(l.account__c);
                if(l.Contact__c != null){
                    lc.setContactId(l.Contact__c);
                }
                lc.setConvertedStatus(CLeadStatus.MasterLabel);
                lc.setDoNotCreateOpportunity(TRUE); //Remove this line if you want to create an opportunity from Lead Conversion 
                MassLeadconvert.add(lc);
            }

        
        if (!MassLeadconvert.isEmpty()) {
            List<Database.LeadConvertResult> lcr = Database.convertLead(MassLeadconvert,false);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. disaster averted!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        system.debug(job);
    } 
}