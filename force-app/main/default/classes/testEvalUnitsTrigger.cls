@isTest
public class testEvalUnitsTrigger
{
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void EvalRequestTriggerTest () {
        User u = [SELECT Id, Manager.Contact_ID__c,Contact_ID__c,managerId FROM User WHERE Id= :UserInfo.getUserId() Limit 1] ;
        contact o = [Select Id, UserId__c from Contact where UserId__c = :UserInfo.getUserId() limit 1];
        Account a = [Select Id, Name,Type,billingstate from Account where name ='ZZpbest' limit 1];
        
        
        
        Contact con = new Contact(FirstName='Random',LastName='ApexTest', email='apextest3@apexmail.com', phone='9995557865',AccountId=a.id,MailingState='ZZ');
        insert con;
        
        system.debug('user conid '+u.Contact_ID__c);
        
        Product2 p = new product2();
        p.name = 'ifp6532';
        p.productcode = 'ifp6532';
        p.isactive = true;
        insert p;       
        
        
        test.startTest();
        Eval_Request__c e = new Eval_Request__c(
            Expected_Receive_Date__c= date.today(),
            Evaluation_Owner__c = o.Id
            
        ); 
        insert e;
        
        List<Eval_Unit_Details__c> units = new List<Eval_Unit_Details__c>();
        
        Eval_Unit_Details__c eu1 = new Eval_Unit_Details__c(
            Eval_Request__c= e.Id,
            Name='1521841545'            
        ); 
        units.add(eu1); 
        
        Eval_Unit_Details__c eu2 = new Eval_Unit_Details__c(
            Eval_Request__c= e.Id,
            Name='18548415487',
            sku_text__c = 'ifp6532-5'
        ); 
        
        units.add(eu2); 
        
        insert units;
        
        TriggerContextUtility.setFirstRunTrue();
        
        eu2.name = '3234234';
        update eu2;
               
        Set<Id> evals = new set<Id>();
        evals.add(eu2.Eval_Request__c);
        EvalUnitsMasterClass.evalstatus(evals);
        
        
        Eval_Unit_Details__c eu3 = [Select id, sku__c ,sku_text__c from Eval_Unit_Details__c where id =: eu2.Id limit 1];
        test.stopTest();
        
        
        
        system.assertEquals(p.Id, eu3.sku__c);
        
    }
    
}