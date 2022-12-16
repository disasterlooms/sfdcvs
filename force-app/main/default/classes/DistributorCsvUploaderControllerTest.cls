@isTest
public class DistributorCsvUploaderControllerTest
{
    @isTest
    static void testDistributorCsvUploaderController()
    {
        List<Account> accts = new List<Account> ();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('VSE/I Account Channel Partner').getRecordTypeId();
        for (CsvUploaderMapping__mdt mapping: CsvUploaderMapping__mdt.getAll().values())
        {
            accts.add(new Account(Name = mapping.MasterLabel, RecordTypeId = devRecordTypeId, Industry = 'Education', BillingCountry = 'United States', BillingState = 'California'));
        }
        insert accts;

        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'newUser', Email = 'newuser@testorg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newtestuser@viewsonic.test.com');

        System.runAs(u) {
            Map<String, List<String >> mappingLabel2Objects = DistributorCsvUploaderController.getMappingLabel2ObjectName();
            if (mappingLabel2Objects.size()> 0)
            {
                List<String> labels = new List<String> ();
                labels.addAll(mappingLabel2Objects.keySet());
                DistributorCsvUploaderController.getCsvMapping(labels[0], mappingLabel2Objects.get(labels[0])[0]);
                DistributorCsvUploaderController.createSellThroughReportImports(labels[0], 'identifier test', new List<Sell_Through_Report_Import__c> {
                    new Sell_Through_Report_Import__c()
                });
                DistributorCsvUploaderController.createStockReportImports(labels[0], 'identifier test', new List<Stock_Report_Import__c> {
                    new Stock_Report_Import__c()
                });   
            }
        }
    }
}