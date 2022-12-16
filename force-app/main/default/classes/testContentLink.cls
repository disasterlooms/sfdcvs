@IsTest
public class testContentLink  {
   @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void testMasterTrigger() {
        
        test.startTest();
        
         Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the');
        ContentVersion conVer = new ContentVersion(
                Title='SampleTitle', 
                PathOnClient ='SampleTitle.jpg',
                VersionData = bodyBlob, 
                origin = 'H'
            );
            insert conVer;      
       
        
               
        Account a = [Select id from account where isPartner = true limit 1];
        ContentVersion vers = [SELECT Id,Library__c ,contentdocumentId FROM ContentVersion where id =: conVer.Id limit 1];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = vers.contentdocumentId;
        cdl.LinkedEntityId = a.Id;
        insert cdl;             
        
        ContentDocumentLink cd = [Select id, visibility, ShareType from ContentDocumentLink where id =: cdl.Id limit 1];
        
        test.stopTest();
        system.assertEquals(cd.Visibility, 'AllUsers');
        system.assertEquals(cd.ShareType, 'I');
        
    }
    
}