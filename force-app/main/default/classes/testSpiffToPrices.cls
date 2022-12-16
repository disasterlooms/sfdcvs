@isTest
private class testSpiffToPrices {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void getLines()
    {		        
        List<Spiff__c> spiff = new List<Spiff__c>();
         
        List<Pricebookentry> pbedisti = [Select id, pricebook2.name, product2.name from Pricebookentry where isActive = true and pricebook2.name = 'VSA Distributor Price List' limit 1];
        
        Spiff__c sdisti = new Spiff__c (SKU__c = pbedisti[0].product2.name,
                                   SPG__c = 1,
                                   AV__c = 1,
                                   CDW__c = 1,
                                   NSP__c = 1,
                                   Distrubution__c = 1,
                                   ExternalId__c = pbedisti[0].product2.name+pbedisti[0].pricebook2.name,
                                   PriceBook__c = pbedisti[0].pricebook2.name);
        
         spiff.add(sdisti);
        
        List<Pricebookentry> pbecdw = [Select id, pricebook2.name, product2.name from Pricebookentry where isActive = true and pricebook2.name = 'VSA CDW Price List' limit 1];
        
        Spiff__c scdw = new Spiff__c (SKU__c = pbecdw[0].product2.name,
                                   SPG__c = 1,
                                   AV__c = 1,
                                   CDW__c = 1,
                                   NSP__c = 1,
                                   Distrubution__c = 1,
                                   ExternalId__c = pbecdw[0].product2.name+pbecdw[0].pricebook2.name,
                                   PriceBook__c = pbecdw[0].pricebook2.name);
        
         spiff.add(scdw);
        
        List<Pricebookentry> pbeav = [Select id, pricebook2.name, product2.name from Pricebookentry where isActive = true and pricebook2.name = 'VSA AV Solution Partner Price List' limit 1];
        
        //Spiff__c sav = new Spiff__c (SKU__c = pbeav[0].product2.name,
                                   //SPG__c = 1,
                                   //AV__c = 1,
                                   //CDW__c = 1,
                                   //NSP__c = 1,
                                   //Distrubution__c = 1,
                                   //ExternalId__c = pbeav[0].product2.name+pbeav[0].pricebook2.name,
                                   //PriceBook__c = pbeav[0].pricebook2.name);
        
         //spiff.add(sav);
        
        List<Pricebookentry> pbedmr = [Select id, pricebook2.name, product2.name from Pricebookentry where isActive = true and pricebook2.name = 'VSA DMR Price List' limit 1];
        
        //Spiff__c sdmr = new Spiff__c (SKU__c = pbedmr[0].product2.name,
                                   //SPG__c = 1,
                                   //AV__c = 1,
                                   //CDW__c = 1,
                                   //NSP__c = 1,
                                   //Distrubution__c = 1,
                                   //ExternalId__c = pbedmr[0].product2.name+pbedmr[0].pricebook2.name,
                                   //PriceBook__c = pbedmr[0].pricebook2.name);
        
         //spiff.add(sdmr);
        
        
        
        
        insert spiff;
        
        
        test.startTest();
        SpiffToPrices.updateSpiffs();
        test.stopTest();
    }
}