@IsTest
public class testevalBillAcct {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
     Static testmethod void TestEvalContact () {
         
         Contact c = [select id from contact where accountid != null limit 1];
         Eval_Request__c e = new Eval_Request__c(Expected_Receive_Date__c=date.today(),
                                                Billing_Contact_Name__c  = c.Id);
         insert e;
         test.startTest();
         Account a = evalBillAcct.getbillAcct(e.Id);
         evalBillAcct.updateAcct(a);
         test.stopTest();
     
     }

}