public class GovSpendMappingService {
    
    
    public static void handleSearch(String searchId){
        ExportCreditStats esc = getCreditStats(searchId);
        if(esc.hasSufficientCredits && esc.totalRecords>0){
            Decimal totalRecordsDec = Decimal.valueOf(esc.totalRecords);
            totalRecordsDec = totalRecordsDec/100;
            String jobId = generateGUID();
            Integer totalPages = Integer.valueOf(totalRecordsDec.round(System.RoundingMode.CEILING));
            System.enqueueJob(new GovSpendCalloutQueueable(searchId, 1, totalPages, jobId));
        }
        
    }
        
    public static void doMapping(String searchId, Integer pageNumber, Integer totalPages, String jobId){
        List<Staging_GovSpend_Contact__c> stagingContactsToInsert = new List<Staging_GovSpend_Contact__c>();
        Staging_GovSpend_Contact_Header__c header = new Staging_GovSpend_Contact_Header__c(Page_Number__c=pageNumber, Total_Pages__c=totalPages, Job_Id__c=jobId);
        GovSpendCallout gsc = new GovSpendCallout(getApiKey());
		HttpResponse response = gsc.runSavedSearch(searchId, pageNumber);
        if(response.getStatusCode()!=200&&response.getStatusCode()!=201){
            header.Error_Message__c='Unsuccessful status code: '+response.getStatusCode()+' Response: '+response.getBody();
            insert header;
            return;
        }
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        insert header;
        List<Object> a = (List<Object>)responseMap.get('result');
        for(integer i=0; i<a.size(); i++){                    
            Map<String, Object> a0 = (Map<String, Object>)a[i];
            Map<String, Object> organization = (Map<String, Object>)a0.get('Organization');
            Map<string, Object> contact = (Map<String, Object>)a0.get('Contact');
            String conString = JSON.serialize(contact);
            GovSpendContact gscon = (GovSpendContact)JSON.deserialize(conString, GovSpendContact.class);
            String accString = JSON.serialize(organization);
            GovSpendAccount gsacc = (GovSpendAccount)JSON.deserialize(accString, GovSpendAccount.class);
            System.debug(gscon);
            Staging_GovSpend_Contact__c stagingCon = govSpendAccountContactMapping(gscon, gsacc);
            stagingCon.Staging_Govspend_Contact_Header__c=header.id;
            stagingContactsToInsert.add(stagingCon);
        }
        insert stagingContactsToInsert;
    }
    
    public static ExportCreditStats getCreditStats(String searchId){
        GovSpendCallout gsc = new GovSpendCallout(getApiKey());
		HttpResponse response = gsc.exportCreditStats(searchId);
        if(response.getStatusCode()!=200&&response.getStatusCode()!=201){
        	throw new CalloutException('Callout to get Credits information failed');
        }
        ExportCreditStats ecs = (ExportCreditStats)JSON.deserialize(response.getBody(), ExportCreditStats.class);
        return ecs;
    }
    
    
    private static String getApiKey(){
        return [select API_Key__c from CalloutKey__mdt where DeveloperName='GovSpend'].API_Key__c;
    }
    
    public static Staging_GovSpend_Contact__c govSpendAccountContactMapping(GovSpendContact con, GovSpendAccount acc){
        
        return new Staging_GovSpend_Contact__c(FirstName__c=con.FirstName,
                                               LastName__c=con.LastName,
                                               Contact_ID__c=con.ID,
                                               Email__c=con.Email,
                                               Address__c=con.Address,
                                               City__c=con.City,
                                               Phone__c=con.Phone,
                                               State__c=con.State,
                                               StateCode__c=con.StateCode,
                                               Title__c=con.Title,
                                               Plan__c=con.Plan,
                                               Account_Name__c=acc.Name,
                                               Account_Address__c=acc.Address1,
                                               Account_City__c=acc.City,
                                               Account_County__c=acc.County,
                                               Account_State__c=acc.State,
                                               Account_State_Code__c=acc.StateCode,
                                               Account_Website__c=acc.WebSite,
                                               Account_Type__c=acc.AccountType,
                                               Account_Fiscal_Year__c=acc.FiscalYear
                                               );                
        
    }
    
    public static String generateGUID(){
		Blob b = Crypto.GenerateAESKey(128);
		String h = EncodingUtil.ConvertTohex(b);
		String hyphen = '-';
		return h.SubString(0,8) + hyphen + h.SubString(8,12) + hyphen + h.SubString(12,16) + hyphen + h.SubString(16,20) + hyphen + h.substring(20);
	}


}