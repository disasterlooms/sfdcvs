@isTest
public class TestEvalRequestTrigger
{
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void EvalRequestTriggerTest () {
        User u = [SELECT Id, Manager.Contact_ID__c,Contact_ID__c,managerId FROM User WHERE Id= :UserInfo.getUserId() Limit 1] ;
        contact o = [Select Id, UserId__c from Contact where UserId__c = :UserInfo.getUserId() limit 1];
        Account a = [Select Id, Name,Type,billingstate from Account where name ='ZZpbest' limit 1];
        
        Contact con = new Contact(FirstName='Random',LastName='ApexTest',
                                  email='apextest3@apexmail.com', phone='9995557865',AccountId=a.id,MailingStateCode='CA',
                                 MailingCountryCode='US');
        insert con;
        
        system.debug('user conid '+u.Contact_ID__c);
        
        test.startTest();
        Eval_Request__c e = new Eval_Request__c(
            Expected_Receive_Date__c= date.today(),
            Evaluation_Owner__c = o.Id,
            Eval_Type__c = 'End-User/Reseller/Disty Eval'
            
        ); 
        insert e;
        
        TriggerContextUtility.setFirstRunTrue();
        
        e.Product_Status__c = 'Closed';
        update e;
        
        TriggerContextUtility.setFirstRunTrue();
        
        e.Product_Status__c = 'Outstanding';
        update e;
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;         
        
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=testcontent.ContentDocumentId;
        contentlink.LinkedEntityId =e.id;
        
        insert contentlink;
        
        
        
        Eval_Unit_Details__c eu1 = new Eval_Unit_Details__c(
            Eval_Request__c= e.Id,
            Name='1521841545'             
        ); 
        insert eu1; 
        
        Eval_Unit_Details__c eu2 = new Eval_Unit_Details__c(
            Eval_Request__c= e.Id,
            Name='18548415487'             
        ); 
        insert eu2; 
        
        TriggerContextUtility.setFirstRunTrue();
        
        Eval_Request__c e1 = [Select Id,Eval_Quote_Sent_Out__c from Eval_Request__c where id =: e.Id limit 1];
        
        e1.Eval_Quote_Sent_Out__c = true;
        update e1;
        
        TriggerContextUtility.setFirstRunTrue();
        
        e1.Eval_Quote_Sent_Out__c = false;
        update e1;
        test.stopTest();
        
    }
    
}