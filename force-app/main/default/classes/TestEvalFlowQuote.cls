@isTest
public class TestEvalFlowQuote {
    @testSetup
    Private static void BuildTestData(){
        BuildTestData.AddRecords(); 
    }
    static testmethod void testEvalUnitstoQuote(){
        Contact con = [Select id from contact where Account.Name like '%Viewsonic%' limit 1];
        
        Eval_Request__c eval = new Eval_Request__c(
            Expected_Receive_Date__c= date.today(),
            Evaluation_Owner__c = con.id           
        ); 
        
        insert eval;
        
        Pricebookentry pb = [Select id, product2Id from Pricebookentry where isactive = true limit 1];
        
        Pricebook2 low = new Pricebook2(name = 'VSA Product Request Bottom Purchase Price List', isactive =true);
        insert low;
     
        
        Pricebookentry pblow = new Pricebookentry(product2Id = pb.Product2Id, isactive = true, unitprice = 2000, pricebook2Id = low.id);
        
        insert pblow;
        
        
        
        Eval_Quote__c q = new Eval_Quote__c(
                                           Billing_City__c = 'City',
                                           Billing_Country__c = 'Country',
                                           Billing_Company_Name__c ='company x',
                                           Billing_Contact_Email__c ='mail@mailapextest.com',
                                           Billing_Contact_Name__c ='Con Name',
                                           Billing_Contact_Phone__c ='555-1212',
                                           Billing_State__c = 'CA',
                                           Billing_Street__c ='123 main st',
                                           Billing_Zip_Postal__c ='90804',
                                           Eval_Request__c =eval.Id,
        								   Shipping_City__c = 'long beach',
        								   Shipping_State__c= 'ca');
        insert q;
        
        Eval_Unit_Details__c u = new Eval_Unit_Details__c(Eval_Request__c = eval.Id,
                                                         name = 'test',sku__c = pb.Product2Id,
                                                         eval_quote__c = q.Id);
        insert u;
        List<String> units = new List<String>();
        
        units.add(q.Id);
        
        Sales_Tax__c rate = new Sales_Tax__c(name='teststate',
                                             City__c ='long beach',
                                             State_Province__c = 'ca',
                                             STATE_RATE__c  = .09);
        insert rate;
        
        Recycle_Fee__c rf = new Recycle_Fee__c(State_Province__c = 'ca',
                                              name = 'test',
                                              Recycle_Fee__c = 100,
                                              Product__c = pb.Product2Id);
        insert rf;
        
        test.startTest();
        
        evalQuoteflow.getRates(units);
        //test with bad city state combo
        
        q.Shipping_City__c = 'blahblahblah';
        update q;
        
        evalQuoteflow.getRates(units);
        
        test.stopTest();
    }
}