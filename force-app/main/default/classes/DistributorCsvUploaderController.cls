public class DistributorCsvUploaderController
{
    @AuraEnabled
    public static User getUserInfo() {
        return [SELECT UserType, Region__c, ContactId, Contact.AccountId, Contact.Account.Name FROM User WHERE Id =: UserInfo.getUserId()][0];
    }

    @AuraEnabled
    public static Map<String, List<String >> getMappingLabel2ObjectName() {
        Map<String, List<String >> mappingLabel2ObjectNames = new Map<String, List<String >> ();
        for (CsvUploaderMapping__mdt mapping: CsvUploaderMapping__mdt.getAll().values())
        {
            if (!mappingLabel2ObjectNames.containsKey(mapping.MasterLabel)) mappingLabel2ObjectNames.put(mapping.MasterLabel, new List<String> ());
            mappingLabel2ObjectNames.get(mapping.MasterLabel).add(mapping.Object__c);
        }

        User currentUser = getUserInfo();
        Map<String, List<String >> mappingLabel2ObjectNames2 = new Map<String, List<String >> ();        
        for (Account distri: [SELECT Id, Name FROM Account WHERE Name In: mappingLabel2ObjectNames.keySet()])
        {
            if (currentUser.ContactId != null && distri.Id == currentUser.Contact.AccountId)
            {
                mappingLabel2ObjectNames2.put(distri.Name, mappingLabel2ObjectNames.get(distri.Name));
                break;
            }
            else if (currentUser.ContactId == null)
            {
                mappingLabel2ObjectNames2.put(distri.Name, mappingLabel2ObjectNames.get(distri.Name));
            }
        }
        return mappingLabel2ObjectNames2;
    }

    @AuraEnabled
    public static Map<String, String> getCsvMapping(String mappingLabel, String mappingObject)
    {
        Map<String, String> csvHeader2FieldApi = new Map<String, String> ();
        List<CsvUploaderMapping__mdt> mappings = [SELECT Id FROM CsvUploaderMapping__mdt WHERE MasterLabel =: mappingLabel AND Object__c =: mappingObject];
        if (mappings.isEmpty()) return csvHeader2FieldApi;

        CsvUploaderMapping__mdt mappingRec = CsvUploaderMapping__mdt.getInstance(mappings[0].Id);
        Set<String> allMappingFields = Schema.SObjectType.CsvUploaderMapping__mdt.fields.getMap().keySet();
        Map<String, Schema.SObjectField> fieldName2FieldDesc = Schema.getGlobalDescribe().get(mappingRec.Object__c).getDescribe().fields.getMap();
        for (Integer i = 1; i<100; i++)
        {
            String csvHeaderField = 'csvheader_' + i + '__c';
            String objectField = 'objectfield_' + i + '__c';
            if (!allMappingFields.contains(csvHeaderField)) break;

            String csvHeaderFieldValue = String.valueOf(mappingRec.get(csvHeaderField));
            String objectFieldValue = String.valueOf(mappingRec.get(objectField));
            if (String.isEmpty(csvHeaderFieldValue) || String.isEmpty(objectFieldValue)) break;

            if(fieldName2FieldDesc.containsKey(objectFieldValue))
            {
            	String objectFieldType = fieldName2FieldDesc.get(objectFieldValue).getDescribe().getType().name();
            	csvHeader2FieldApi.put(csvHeaderFieldValue, objectFieldValue + ',' + objectFieldType);    
            }
        }
        return csvHeader2FieldApi;
    }

    @AuraEnabled
    public static Map<Integer, String> createSellThroughReportImports(String mappingLabel, String fileIdentifier, List<Sell_Through_Report_Import__c> records)
    {
        Account distributor = getDistributor(mappingLabel);
        for (Sell_Through_Report_Import__c rec: records)
        {
            rec.CsvUploaderFileIdentifier__c = fileIdentifier;
            rec.Ready_to_Sync_to_TCRM__c = true;
            rec.Distributor__c = distributor.Id;
            rec.VS_Region__c = distributor.VSRegion__c;
            rec.VS_SubRegion__c = distributor.VSSubRegion__c;
        }
        return insertObjectRecords(records);
    }

    @AuraEnabled
    public static Map<Integer, String> createStockReportImports(String mappingLabel, String fileIdentifier, List<Stock_Report_Import__c> records)
    {
        Account distributor = getDistributor(mappingLabel);
        for (Stock_Report_Import__c rec: records)
        {
            rec.CsvUploaderFileIdentifier__c = fileIdentifier;
            rec.Ready_to_Sync_to_TCRM__c = true;
            rec.Account__c = distributor.Id;
            rec.VS_Region__c = distributor.VSRegion__c;
            rec.VS_SubRegion__c = distributor.VSSubRegion__c;
        }
        return insertObjectRecords(records);
    }

    public static Account getDistributor(String distriName)
    {
    	List<Account> distributors = [SELECT Id, VSRegion__c, VSSubRegion__c FROM Account WHERE Name =: distriName];
        if (distributors.isEmpty())
        {
            throw new AuraHandledException('The distributor you choosed cannot be found! Please contact system administrator.');
        }
        return distributors[0];
    }
    
    public static Map<Integer, String> insertObjectRecords(List<SObject> records)
    {
        Savepoint sp = Database.setSavepoint();
        Map<Integer, String> lineNum2Error = new Map<Integer, String> ();
        Database.SaveResult[] srList = Database.insert(records, false);
        Integer lineIndex = 0;
        for (Database.SaveResult sr: srList)
        {
            if (!sr.isSuccess() && !sr.getErrors().isEmpty())
            {
                lineNum2Error.put(lineIndex, sr.getErrors()[0].getMessage());
            }
            lineIndex++;
        }
        if (lineNum2Error.size()> 0) Database.rollback(sp);
        return lineNum2Error;
    }
}