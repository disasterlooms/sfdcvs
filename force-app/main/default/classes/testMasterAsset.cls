@IsTest
public class testMasterAsset  {
   @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    } 
    
    Static testmethod void testMasterTrigger() {
        
        test.startTest();
        
        //Get Viewsonic account Id 2 Distributors 2 resellers and 2 end users
        List<Account> accts = [Select id, name,POS_Alias__c from account where name != 'ViewSonic Corporation' limit 4];
        List<Account> vs = [Select id, name from account where name = 'ViewSonic Corporation' limit 1];
        
        accts[3].POS_Alias__c = 'posalias';
        update accts;
        
        // Set Distribution Account
        // Set Reseller Account
        // 
        List<POSAccountAliases__c> aliases = new List<POSAccountAliases__c>();
        
        POSAccountAliases__c p = new POSAccountAliases__c();
        p.DistributorAlias__c = 'disti';
        p.name = 'disti';
        p.SFDC_Account__c = accts[0].Id;
        
        aliases.add(p);
        
        POSAccountAliases__c p2 = new POSAccountAliases__c();
        p2.name = 'Reseller';
        p2.Reseller_Alias__c = 'Reseller';
        p2.SFDC_Account__c = accts[1].Id;
        
        aliases.add(p2);
        
        POSAccountAliases__c p3 = new POSAccountAliases__c();
        p3.name = 'End User';
        p3.End_User_Alias__c = 'End User';
        p3.SFDC_Account__c = accts[2].Id;
        
        aliases.add(p3);
        
        insert aliases;
        
         //Spa Id Relation
        Opportunity opp = [Select id, accountid, spa_id__c from Opportunity where accountId !=: vs[0].Id 
                          limit 1];
        
        List<Asset> newSales = new List<Asset>();
        
        Product2 prod = [Select id,name from product2 limit 1];
        
        Product2 ifp = new product2();
        ifp.name = 'ifp52520';
        ifp.ProductCode = 'ifp52520';
        ifp.IsActive = true;
        insert ifp;
        
        
        Asset vsa = new Asset();
        vsa.TP__c = 'disti';
        vsa.name = 'vsa';
        vsa.AccountId = vs[0].Id;
        vsa.serialnumber = '234w4r4445';
        newSales.add(vsa);
        
        //distributor  alias on pos alias test
        
        Asset dist = new Asset();
        dist.name = 'disti';
        dist.TP__c = 'disti';
        dist.AccountId = vs[0].Id;
        dist.serialnumber = '1234';
        dist.Distributor__c = 'disti';
        newSales.add(dist);
        
        //reseller alias on pos alias test
        
        Asset res = new Asset();
        res.TP__c = 'disti';
        res.name = 'Reseller';
        res.AccountId = vs[0].Id;
        res.serialnumber = '2345745';
        res.Reseller__c = 'Reseller';
        newSales.add(res);
        
        //end user alias on pos alias test
        
        Asset eu = new Asset();
        eu.TP__c = 'disti';
        eu.name = 'aseteu';
        eu.AccountId = vs[0].Id;
        eu.serialnumber = '23484ii4453';
        eu.end_user__c = 'End User';
        newSales.add(eu);
        
        //spa id test
        Asset spa = new Asset();
        spa.TP__c = 'disti';
        spa.name = 'asetspa';
        spa.AccountId = vs[0].Id;
        spa.serialnumber = '234w4re25';
        spa.SpaId__c = opp.Spa_id__c;
        newSales.add(spa);
        
        //spa id test
        Asset spa2 = new Asset();
        spa2.TP__c = 'disti';
        spa2.name = 'asetspa';
        spa2.AccountId = vs[0].Id;
        spa2.serialnumber = '12341w4r5';
        spa2.SpaId2__c = opp.Spa_id__c;
        newSales.add(spa2);
        
        //pos alias on account test
        Asset eualias = new Asset();
        eualias.TP__c = 'disti';
        eualias.name = 'posalias';
        eualias.AccountId = vs[0].Id;
        eualias.serialnumber = '234w49j9jr5';
        eualias.end_user__c = 'posalias';
        eualias.product__c = prod.Name;
        newSales.add(eualias);
       
        //Test for the -2 removal on IFP models
        Asset ifplias = new Asset();
        ifplias.TP__c = 'disti';
        ifplias.name = 'posaliasifp';
        ifplias.AccountId = vs[0].Id;
        ifplias.serialnumber = '234wee149j9jr5';
        ifplias.end_user__c = 'posaliasifp';
        ifplias.product__c = ifp.Name+'-2';
        newSales.add(ifplias);
        
        PricebookEntry pbe = [Select id from PricebookEntry where pricebook2.name = 'VSA Distributor Price List' and isactive = true limit 1];
        Quote q = [select id from quote where name = 'apext test' limit 1];
        
        
        QuoteLineItem qte = new QuoteLineItem();
        qte.pricebookentryid = pbe.id;
        qte.UnitPrice = 100;
        qte.Quantity = 45;
        qte.quoteId = q.Id;        
        
        insert qte;
        
        
         //qte = [Select id,Quote.Name,product2Id ,product2.name ,quote.Opportunity.Spa_id__c from QuoteLineItem 
                           // order by quote.expirationdate desc nulls last limit 1]; 
        Account acct  = [Select id, name from account where name ='usditi' limit 1];
        Contact var = [Select id, name from contact limit 1];
        
        
        
        Asset spalias = new Asset();
        spalias.TP__c = 'disti';
        spalias.SpaId__c = qte.Quote.Opportunity.Spa_id__c;        
        spalias.name = 'posaliasifp';
        spalias.AccountId = vs[0].Id;
        spalias.serialnumber = 'Quote234wee149j9jr5232';
        spalias.end_user__c = 'posaliasifp';
        spalias.product__c = qte.product2.name;
        newSales.add(spalias);
              
         
        
        insert newSales;
        
        newSales[0].name= 'posaliasq';
        
        TriggerContextUtility.setFirstRunTrue();
        update newSales;
       
       
        List<Asset> addedAssets = [Select id, AccountId from asset
                                   where AccountId !=: vs[0].Id ];
        
        List<Asset> addedAssetsvsProd = [Select id,product2Id,product__c, AccountId from asset
                                    where product__c =: prod.Name];
        
        List<Asset> addedAssetsvsProdifp = [Select id,product2Id,product__c, AccountId from asset
                                    where product__c like '%ifp52%'];
        
        List<Asset> addedAssetsvs = [Select id,product2Id,product__c, AccountId from asset
                                         ];
        
        //Asset sTest = [Select id, Spa_Product__c from Asset where id =:spalias.Id];
        test.stopTest();
        
        //system.debug('QId and Asset QId '+qte.Id+' '+sTest.Spa_Product__c);
        //system.assertEquals(qte.Id , sTest.Spa_Product__c);
        
        system.debug(addedAssets);
        //system.assertEquals(5,addedAssets.size());
        system.assertEquals(9,addedAssetsvs.size());
        system.assertEquals(prod.Id,addedAssetsvsProd[0].product2Id);
        system.assertEquals(ifp.Id,addedAssetsvsProdifp[0].product2Id);
        
        
        
    }
}