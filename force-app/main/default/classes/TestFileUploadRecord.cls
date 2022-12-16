@isTest
public class TestFileUploadRecord {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void casecreate(){
     
        
        String whatdoing = 'blah blah';
        String wherepage = 'blah blah';
        String docid = '';
        String subject = 'some test subject';
        String mssg = 'blah blah';
        String recid = 'blah blah';
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;         
        
        ContentVersion content = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        
        docid = content.ContentDocumentId;
        
        test.startTest();
        FileUploadRecord.getId();
        FileUploadRecord.updateRecords(whatdoing, wherepage, docid, subject, mssg, recid);

    } 

}