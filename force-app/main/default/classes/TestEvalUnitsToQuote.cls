@isTest
public class TestEvalUnitsToQuote {
    @testSetup
    Private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    //test pass 10.27
    
    static testmethod void testGetAccessCheck(){
        boolean result = EvalUnitstoQuote.getAccessCheck();
        //system.assertEquals(true, result);
    }
    static testmethod void testEvalUnitstoQuote(){
        test.startTest();
        Contact con = [Select id from contact where Account.Name like '%Viewsonic%' limit 1];
        
        Eval_Request__c eval = new Eval_Request__c(
            Expected_Receive_Date__c= date.today(),
            Evaluation_Owner__c = con.id           
        ); 
        
        insert eval;
        
        Eval_Unit_Details__c u = new Eval_Unit_Details__c(Eval_Request__c = eval.Id,
                                                          name = 'test');
        insert u;
        
        Eval_Quote__c q = new Eval_Quote__c(Billing_City__c = 'City',
                                            Billing_Country__c = 'Country',
                                            Billing_Company_Name__c ='company x',
                                            Billing_Contact_Email__c ='mail@mailapextest.com',
                                            Billing_Contact_Name__c ='Con Name',
                                            Billing_Contact_Phone__c ='555-1212',
                                            Billing_State__c = 'CA',
                                            Billing_Street__c ='123 main st',
                                            Billing_Zip_Postal__c ='90804',
                                            Eval_Request__c =eval.Id);
        insert q;
        
       
        List<Eval_Unit_Details__c> units = EvalUnitstoQuote.getUnits(eval.Id);
        system.debug('size of units '+units.size());
        
        
        system.assert(units.size()==1);
        
        EvalUnitstoQuote.updateUnits(units, q.Id);
        EvalUnitstoQuote.updateSelected(units); 
        test.stopTest();
    }
}