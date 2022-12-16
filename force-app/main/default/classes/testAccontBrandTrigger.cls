@IsTest
public class testAccontBrandTrigger  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void MasterAcountBrand() {
        TriggerContextUtility.setFirstRunFalse();
        test.startTest();
        Account a = [Select id,name from account limit 1];
        
        AccountBrand ab = new AccountBrand();
        ab.AccountId = a.Id;
        ab.Name = a.Name;
        insert ab;
        
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the');
        ContentVersion conVer = new ContentVersion(
                Title='SampleTitle', 
                PathOnClient ='SampleTitle.jpg',
                VersionData = bodyBlob, 
                origin = 'H'
            );
            insert conVer;
       
        ContentVersion contCr = [SELECT Id, Title, ContentDocumentId 
                            FROM ContentVersion WHERE Id = :conVer.Id LIMIT 1];
        
        ContentDocument cd = [Select id, ContentAssetId from ContentDocument where id = : contCr.ContentDocumentId];
        
        ContentAsset ac = new contentasset();
        //ac.ContentDocumentId = conVer.Id;
        ac.DeveloperName = 'testnewlogofileblah';
        ac.IsVisibleByExternalUsers = true;
        ac.MasterLabel = 'testnewlogofileblah';
        insert ac;
        
        cd.ContentAssetId = ac.Id;
        update cd;        
        
        //ContentAsset ca = [Select id, ContentDocumentId from ContentAsset where id =: conVer.Id limit 1];
             
        AccountBrand upB = [Select id, logoId from accountbrand where id =:ab.Id];
        
        
        TriggerContextUtility.setFirstRunFalse();
        upB.LogoId = ac.Id;
        update upB;
        AccountBrand updated = [Select id, FileId__c,fileURLThumbnail__c from accountbrand where id =:ab.Id];       
        
       test.stopTest();
        
        system.assertEquals(updated.FileId__c, cd.Id);
        system.assertNotEquals(updated.fileURLThumbnail__c, '');
        
        
        
    }
    
}