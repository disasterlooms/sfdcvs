@IsTest
public class testLegacyFinchSpiffSerials  {
   @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void testMasterTrigger() {
        
        test.startTest();
        //build test data will cover the class currently. This is set up for future testing
        //on the master class
        List<Account> vs = [Select id, name from account where name = 'ViewSonic Corporation' limit 1];
        
        Asset vsa = new Asset();
        vsa.TP__c = 'disti';
        vsa.name = 'vsa';
        vsa.AccountId = vs[0].Id;
        vsa.serialnumber = '234w4r4445';
        insert vsa;
        
        Spiff_request__c spiff = [Select id,Legacy_Spiff_Claim_Id__c from Spiff_request__c limit 1];
        spiff.Legacy_Spiff_Claim_Id__c = '12455';
        update spiff;
        TriggerContextUtility.setFirstRunTrue();
        finchLegacySerialNumbers__c fs = new finchLegacySerialNumbers__c();
        fs.SerialNumber__c = '234w4r4445';
        fs.legacySpiffId__c = '12455';
        insert fs;
        
        TriggerContextUtility.setFirstRunTrue();
        fs.SaleDate__c = date.today();
        update fs;
        
        delete fs;
        
        
        TriggerContextUtility.setFirstRunTrue();
        finchLegacySerialNumbers__c fsa = new finchLegacySerialNumbers__c();
        fsa.SerialNumber__c = '234w4r4445333';
        fsa.legacySpiffId__c = '12455';
        insert fsa;
        
        test.stopTest();
        
        Asset upAss = [Select id, Spiff_Request__c from Asset where id = : vsa.Id];
        system.assertEquals(upAss.Spiff_Request__c, spiff.Id);
        
    }
    
}