@IsTest
public class Testcountattachment {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void Testcountattachment() {
        
            Eval_Request__c eval = [Select id from Eval_Request__c limit 1];

        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=eval.id;
        insert attach;
        
        
        
        
        delete attach;
        }
       
 }