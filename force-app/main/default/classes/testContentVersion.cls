@IsTest
public class testContentVersion  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void MasterAcountBrand() {
        TriggerContextUtility.setFirstRunFalse();
        test.startTest();
        Account a = [Select id,name from account limit 1];
        
        ContentWorkspace wk = new ContentWorkspace();
        wk.name = 'W9';
        //database.insert (wk,false);
        
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the');
        ContentVersion conVer = new ContentVersion(
                Title='SampleTitle', 
                PathOnClient ='SampleTitle.jpg',
                VersionData = bodyBlob, 
                origin = 'H'
            );
            insert conVer;       
       
        
               
        
        ContentVersion vers = [SELECT Id,Library__c ,contentdocumentId FROM ContentVersion where id =: conVer.Id limit 1];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = vers.contentdocumentId;
        cdl.LinkedEntityId = a.Id;
        insert cdl;             
        
        vers.Library__c  = 'W9';
        TriggerContextUtility.setFirstRunFalse();
        update vers;
        
        vers.Library__c  = 'Partner Portal Archives';
        TriggerContextUtility.setFirstRunFalse();
        update vers;
        
        
       test.stopTest();
        List<ContentDocumentLink> cdlink = [Select id from ContentDocumentLink where contentdocumentId =: vers.contentdocumentId limit 1];
        List<ContentWorkspaceDoc> cwd  = [Select id, contentdocumentId,ContentWorkspaceId
                                          from ContentWorkspaceDoc where contentdocumentId =: vers.contentdocumentId limit 1];     
        
      system.assertEquals(cdlink.size(),1);
      system.assertNotEquals(cwd[0].ContentWorkspaceId, wk.Id);
      
        
        
    }
    
}