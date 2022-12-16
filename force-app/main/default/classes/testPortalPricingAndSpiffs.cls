@isTest
private class testPortalPricingAndSpiffs {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    @isTest
    static void testpricingSearch(){      
        
        test.startTest();
        PricingEffectiveDate__c p = new PricingEffectiveDate__c();
        p.Effective_Date__c = Date.today();
        p.Name = 'PricingDate';
        insert p;
        
        List<Portal_Pricing__c> pric = new List<Portal_Pricing__c>();
        
        Portal_Pricing__c pp1 = new Portal_Pricing__c();
        pp1.Effective_Date__c = Date.today();
        pp1.Spiff_Amount__c = 200;
        pp1.Country__c = 'United States';
        pp1.Product__c = 'CDE2303';
        pric.add(pp1);
        
        Portal_Pricing__c pp2 = new Portal_Pricing__c();
        pp2.Effective_Date__c = Date.today()-1;
        pp2.Country__c = 'United States';
        pp2.Product__c = 'CDE2303';
        pp2.Spiff_Amount__c = 200;
        pric.add(pp2);
        
        insert pric;        
       
        spiff_request__c spiff = [Select id from spiff_request__c limit 1];
        
        Boolean spiffReq = true;
        String prod = 'cde';
        portalPricingAndSpiffs.getProductInfo(spiffReq, prod);
        
        spiffReq = false;
        portalPricingAndSpiffs.getProductInfo(spiffReq, prod);
        spiffReq = true;
        portalPricingAndSpiffs.getAdminRecords(spiffReq, prod, spiff.Id);
        test.stopTest();
        
    }
}