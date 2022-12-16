@isTest
private class testCountryStatesLWC {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void testgetBillingAddresses()  
    {
        
        test.startTest();
        
        Contact con = [Select id from contact where Account.Name like '%Viewsonic%' limit 1];
        Contact nonVS = [Select id from contact where id != :con.Id limit 1];
        List<Eval_Request__c> records = new List<Eval_Request__c>();
        
        Eval_Request__c eval = new Eval_Request__c(
            Expected_Receive_Date__c= date.today(),
            Evaluation_Owner__c = con.id,
            Reseller_Contact_Name__c = con.id
        ); 
        
        records.add( eval);
        Eval_Request__c eval2 = new Eval_Request__c(
            Expected_Receive_Date__c= date.today(),
            Reseller_Contact_Name__c = nonVS.Id,
            Shipping_Contact_Name__c = nonVS.Id
        ); 
        
        records.add( eval2);
        insert records;
        
        Eval_Unit_Details__c u = new Eval_Unit_Details__c(Eval_Request__c = eval.Id,
                                                          name = 'test');
        insert u;
        
        countryStatesLWC.getCountries();
        countryStatesLWC.getStates();
        
        countryStatesLWC.getAddresses(con.Id);
        countryStatesLWC.getBillingAddresses(eval.Id);
        
        test.stopTest();
    }
    
}