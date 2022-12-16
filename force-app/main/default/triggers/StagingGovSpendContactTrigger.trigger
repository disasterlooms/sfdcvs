trigger StagingGovSpendContactTrigger on Staging_Govspend_Contact__c (before insert) {
	
    if(Trigger.isInsert){
        
        List<Staging_Govspend_Contact__c> upsertIntoLeads = new List<Staging_Govspend_Contact__c>();
        List<Staging_Govspend_Contact__c> updateIntoContacts = new List<Staging_Govspend_Contact__c>();
        List<Lead> leadsToUpsert = new List<Lead>();
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Id> campaignMemberstoCreate = new List<Id>();
        
        Set<String> stagingEmails = new Set<String>();
        Map<String, Contact> emailsToContacts = new Map<String, Contact>();
        Map<String, Lead> emailsToLeads = new Map<String, Lead>();
        for(Staging_Govspend_Contact__c sgc: Trigger.New){
            stagingEmails.add(sgc.Email__c);
        }
        List<Lead> emailLeadMatches = [select id, GovSpend_ID__c, Email from Lead where Email in :stagingEmails];
        List<Contact> emailContactMatches = [select id, GovSpend_ID__c, Email from Contact where Email IN :stagingEmails];
        for(Contact c: emailContactMatches){
            if(emailsToContacts.keySet().contains(c.Email)){
                if(emailsToContacts.get(c.Email).GovSpend_ID__c!=null){
                	continue; //if we found two Contacts with the same Email, we want to make sure we only update the Contact that already has a GovSpend external ID. If none of them have GovSpend IDs it doesnt matter which one we update
                }
            }
            emailsToContacts.put(c.Email, c);
        }        

        for(Lead l: emailLeadMatches){
            if(emailsToLeads.keySet().contains(l.Email)){
                if(emailsToLeads.get(l.Email).GovSpend_ID__c!=null){
                	continue; //if we found two Contacts with the same Email, we want to make sure we only update the Contact that already has a GovSpend external ID. If none of them have GovSpend IDs it doesnt matter which one we update
                }
            }
            emailsToLeads.put(l.Email, l);
        }        
        Set<String> uniqueEmailsUsed = new Set<String>();
        for(Staging_Govspend_Contact__c sgc: Trigger.New){
            if(sgc.Email__c!=null&&sgc.Email__c!=''&&emailsToContacts.keySet().contains(sgc.Email__c) && !uniqueEmailsUsed.contains(sgc.Email__c)){ //if Contact with existing email is found, we want to update contact with GovSpend ID
                Contact c = emailsToContacts.get(sgc.Email__c);
                c.GovSpend_ID__c = sgc.Contact_ID__c;
                contactsToUpdate.add(c);
                updateIntoContacts.add(sgc);
                uniqueEmailsUsed.add(sgc.Email__c);
            }
            else if(sgc.Email__c!=null&&sgc.Email__c!=''&&emailsToLeads.keySet().contains(sgc.Email__c) && !uniqueEmailsUsed.contains(sgc.Email__c)){
                Lead l = emailsToLeads.get(sgc.Email__c);
                l.GovSpend_ID__c=sgc.Contact_ID__c;
                leadsToUpsert.add(l);
                upsertIntoLeads.add(sgc);
                uniqueEmailsUsed.add(sgc.Email__c);
            }
            else if (sgc.Email__c!=null){ //otherwise, we just upsert a Lead by default
                Lead l = new Lead(GovSpend_ID__c=sgc.Contact_ID__c,
                                  FirstName=sgc.FirstName__c,
                                  LastName=sgc.LastName__c,
                                  Email=sgc.Email__c,
                                  Street=sgc.Address__c,
                                  City=sgc.City__c,
                                  Phone=sgc.Phone__c,
                                  //State=sgc.State__c,
                                  CountryCode='US',
                                  StateCode=sgc.StateCode__c,
                                  Title=sgc.Title__c,
                                  Plan__c=sgc.Plan__c,
                                  Company=sgc.Account_Name__c,
                                  HasOptedOutOfEmail=true,
                                  GovSpend_Account_Street__c=sgc.Account_Address__c,
                                  GovSpend_Account_City__c=sgc.Account_City__c,
                                  GovSpend_Account_County__c=sgc.Account_County__c,
                                  GovSpend_Account_State__c=sgc.Account_State__c,
                                  GovSpend_Account_Type__c=sgc.Account_Type__c
                                  /*Account_State_Code__c=acc.StateCode,
                                    Account_Website__c=acc.WebSite,
                                    Account_Type__c=acc.AccountType,
                                    Account_Fiscal_Year__c=acc.FiscalYear*/
                                  );
                leadsToUpsert.add(l);
                upsertIntoLeads.add(sgc);
            }
            else{
                sgc.Errors__c='GovSpend Contact email already matched with a Contact or Lead in the system, or no email was found on this Contact.';
            }
        }
        Database.UpsertResult[] upsertResults = Database.upsert(leadsToUpsert, false);
        Database.SaveResult[] updateResults = Database.update(contactsToUpdate, false);
        
        for(integer i = 0; i < updateResults.size(); i++){
            Database.SaveResult sr = updateResults[i];
            Staging_Govspend_Contact__c sgc = updateIntoContacts[i];
            if(sr.isSuccess()){
                sgc.Success__c=true;
                sgc.Operation_Type__c= 'Update Contact';
                campaignMemberstoCreate.add(sr.getId());
            }
            else{
                sgc.Errors__c=String.valueOf(sr.getErrors());
            }

        }
        
        for(integer i = 0; i < upsertResults.size(); i++){
            Database.UpsertResult ur = upsertResults[i];
            Staging_Govspend_Contact__c sgc = upsertIntoLeads[i];
            if(ur.isSuccess()){
                sgc.Success__c=true;
                sgc.Operation_Type__c= ur.isCreated() ? 'Insert Lead' : 'Update Lead';
                campaignMemberstoCreate.add(ur.getId());
            }
            else{
                sgc.Errors__c=String.valueOf(ur.getErrors());
            }
            
        }
    List<CampaignMember> campaignMembersToInsert = new List<CampaignMember>();
    Set<Id> campaignMembersAlreadyExist = new Set<Id>();
	List<Campaign> camp = [select id from Campaign where name=:System.Label.GovSpend_Campaign_Name ];
	List<CampaignMember> campMems = [select LeadId, ContactId from CampaignMember where LeadId IN :campaignMemberstoCreate or ContactId IN :campaignMemberstoCreate];
    for(CampaignMember campMem : campMems){
        if(campMem.LeadId!=null) campaignMembersAlreadyExist.add(campMem.LeadId);
        else if(campMem.ContactId!=null) campaignMembersAlreadyExist.add(campMem.ContactId);
    }
    if(camp.size()>0){
        for(Id i : campaignMemberstoCreate){
            if(campaignMembersAlreadyExist.contains(i)){
                continue;
            }
            else{
                CampaignMember c = new CampaignMember(CampaignId=camp[0].Id);
                if(i.getSObjectType()==Schema.Lead.SObjectType) c.LeadId = i;
                else c.ContactId= i;
                campaignMembersToInsert.add(c);
            }
            
        }
        insert campaignMembersToInsert;
    }   
    
    }
    
}