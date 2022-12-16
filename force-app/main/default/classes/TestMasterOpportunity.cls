@IsTest
public class TestMasterOpportunity  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords(); 
        
    }
    
    Static testmethod void MasterOppInsert() {
        TriggerContextUtility.setFirstRunFalse();
        //Query the test records needed to create opportunities
        //Query Products, different account type and contacts associated with opportunity
        Test.startTest();
        
        Product2 prod =[Select Id, Name from Product2 where Name ='Apex Test' Limit 1];
        Account acc = [Select Id,Name,Type,BillingState from Account where name ='ZZpbest' Limit 1];
        Contact con = [Select Id, Name,Email from Contact where LastName= 'ApexTest' and email != '' Limit 1];
         
        Account edu = new Account(Name='ZZpbestEDdausidfhas',Duplicate_Rule_Suppres__c  = true, BillingCountryCode ='US',BillingStreet='123 main afasef',
                                           website = 'Zpbaasdfasdfasdfasfdsfesst.org',Industry='Education',BillingCity='citydfasdfasdfsome',billingPostalCode='7382342342389',BillingStateCode='CA' ,Type ='End User');
        
        Database.DMLOptions dml = new Database.DMLOptions(); 
        dml.DuplicateRuleHeader.allowSave = true;
        database.insert (edu,dml);        
        Account acccdw = [Select Id from Account where Name ='Cdw LLC' Limit 1];
        
        Pricebook2 pbNew = new Pricebook2();
        pbNew.Channel_Pricing__c = 'France Euro Standard';
        pbNew.Name = 'VSE Standard FRN Euro';
        pbNew.CurrencyIsoCode__c = 'EUR';
        pbNew.isActive = true;     
        insert pbNew;
        
        
        List<Opportunity> oppsToInsert = new List<Opportunity>();
        
        Opportunity opp = new Opportunity(Name = 'Apex disti Test',AccountID = acc.Id,Partner_Account_Search__c = acc.Id,
                                          ResellerContact__c = con.Id,
                                          Amount = 2000,CloseDate=Date.today(),StageName='Distributor SPA Request',Type='New Customer',
                                          Test_Opportunity__c=True, ApexTest__c= true );
        
        Opportunity oppPB = new Opportunity(Name = 'Apex disti Test',AccountID = acc.Id,Partner_Account_Search__c = acc.Id,
                                          ResellerContact__c = con.Id,Channel__c = pbNew.channel_pricing__c,
                                          Amount = 2000,CloseDate=Date.today(),StageName='Development',Type='Project',
                                          Test_Opportunity__c=True, ApexTest__c= true );
        
        oppsToInsert.add(oppPB);
        
       Opportunity dist = new Opportunity(Name = 'Apex Test',AccountID = acc.Id,Amount = 2000,CloseDate=Date.today(),
                                          StageName='Close Won',Type='New Customer',
                                          Test_Opportunity__c=True, ApexTest__c= true );
        
        
        
        oppsToInsert.add(dist);
        
         
        
        
        
        Opportunity oppus = new Opportunity(Name = 'Apex Test',End_User_Lookup_Account__c = acc.Id,Partner_Account_Search__c = acc.id, 
                                            Amount = 2000,CloseDate=Date.today(),StageName='Close Won',Type='New Customer',
                                            Test_Opportunity__c=True,End_User_Contact__c= con.id,
                                            ResellerContact__c = con.id, Product_Name_Main__c = prod.id,
                                            Product_Quantity__c=50, Country__c ='United States',ApexTest__c= true  );
        
        oppsToInsert.add(oppus);
        
        
        Opportunity oppObj4 = new Opportunity(Name = 'Apex Test',End_User_Lookup_Account__c = edu.Id,Partner_Account_Search__c = acccdw.id, 
                                              Amount = 2000,CloseDate=Date.today(),StageName='Development',Type='New Customer', 
                                              Test_Opportunity__c=True,End_User_Contact__c= con.id,
                                              Product_Sales_Price__c=200,Reseller_Contact_Name__c='Some Cool Test Name',Reseller_Contact_Email__c='mrcool@apextesting.com',
                                              Country__c= 'United States' , Product_Name_Main__c = prod.Id , Product_Quantity__c =10,ApexTest__c= true );
        
        oppsToInsert.add(oppObj4);
        
        Opportunity oppObj66 = new Opportunity(Name = 'Apex Test',End_User_Lookup_Account__c = edu.Id,Partner_Account_Search__c = acccdw.id, 
                                              Amount = 2000,CloseDate=Date.today(),StageName='Development',Type='New Customer', 
                                              Test_Opportunity__c=True,End_User_Contact__c= con.id,
                                              Product_Sales_Price__c=200,Reseller_Contact_Name__c='Some Cool Test Name',Reseller_Contact_Email__c='mrcool@apextesting.com',
                                              Country__c= edu.BillingCountry , Product_Name_Main__c = prod.Id , Product_Quantity__c =10,ApexTest__c= true );
        
        oppsToInsert.add(oppObj66);
        
        Opportunity can = new Opportunity(Name = 'Apex Test',End_User_Lookup_Account__c = acc.Id,Partner_Account_Search__c = acc.id, 
                                           Amount = 2000,CloseDate=Date.today(),StageName='Development',Type='New Customer',
                                           Test_Opportunity__c=True,End_User_Contact__c= con.id, Country__c ='Canada',
                                           Product_Sales_Price__c=200,Product_Name_Main__c=prod.id, Product_Quantity__c=50, ApexTest__c= true );
        
        oppsToInsert.add(can);
        
        Opportunity opp8 = new Opportunity(Name = 'Apex Test',End_User_Lookup_Account__c = edu.Id,Partner_Account_Search__c = acc.id, 
                                           Amount = 2000,CloseDate=Date.today(),StageName='Development',Type='New Customer',
                                           Test_Opportunity__c=True,End_User_Contact__c= con.id, Country__c ='Canada',
                                           Product_Sales_Price__c=200,Product_Name_Main__c=prod.id, Product_Quantity__c=50, ApexTest__c= true );
        
        oppsToInsert.add(opp8);
        
         Opportunity disti = new Opportunity(Name = 'Apex Test',End_User_Lookup_Account__c = edu.Id,Partner_Account_Search__c = acc.id, ResellerContact__c = null,
                                           Amount = 2000,CloseDate=Date.today(),StageName='Distributor SPA Request',Type='New Customer',
                                           Test_Opportunity__c=True,End_User_Contact__c= con.id, Country__c ='Canada',Cloning__c = false,
                                           Product_Sales_Price__c=200,Product_Name_Main__c=prod.id, Product_Quantity__c=50, ApexTest__c= true );
        
        oppsToInsert.add(disti);
        
        
        Opportunity disti2 = new Opportunity(Name = 'Apex Test',End_User_Lookup_Account__c = edu.Id,Partner_Account_Search__c = acc.id, ResellerContact__c = con.id,
                                           Amount = 2000,CloseDate=Date.today(),StageName='Distributor SPA Request',Type='New Customer',
                                           Test_Opportunity__c=True,End_User_Contact__c= con.id, Country__c ='Canada',Cloning__c = false,
                                           Product_Sales_Price__c=200,Product_Name_Main__c=prod.id, Product_Quantity__c=50, ApexTest__c= true );
        
        oppsToInsert.add(disti2);
        
        User uguest = [Select id from user where alias = 'guest' and isactive = true limit 1];
        
        Opportunity res = new Opportunity(Name = 'Apex Test',End_User_Lookup_Account__c = edu.Id,Partner_Account_Search__c = acc.id, 
                                           Amount = 2000,CloseDate=Date.today(),StageName='Development',Type='New Customer',ResellerContact__c = con.Id,
                                           Test_Opportunity__c=True,End_User_Contact__c= con.id, Country__c ='Canada',Cloning__c = false,
                                           Product_Sales_Price__c=200,Product_Name_Main__c=prod.id, Product_Quantity__c=50, ApexTest__c= true ,Ownerid = uguest.Id);
        
        oppsToInsert.add(res);
        
        
        
        database.insert (oppsToInsert,false);
        
        Opportunity oppqueried = [Select id from opportunity where country__c = 'United States' limit 1];
        Pricebookentry pbe = [Select Id,Pricebook2Id from Pricebookentry where isactive = true and pricebook2.name = 'VSA Distributor Price List' limit 1];
        
        
        OpportunityLineItem oline = new OpportunityLineItem(PricebookentryID = pbe.Id,
                                                            OpportunityId = oppqueried.Id,
                                                            Quantity = 10,
                                                            UnitPrice = 300);
        
        insert oline; 
        
        TriggerContextUtility.setFirstRunTrue();
        OpportunityLineItem doline = new OpportunityLineItem(PricebookentryID = pbe.Id,
                                                            OpportunityId = disti.Id,
                                                            Quantity = 10,
                                                            UnitPrice = 300);
        
        database.insert (doline,false);
        
        
        
        
        
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        
        
        
        /*
        TriggerContextUtility.setFirstRunTrue();
        
        disti.StageName = 'Distributor SPA Request';
        oppsToUpdate.add(disti);
        
        oppsToUpdate.add(oppus);
       
        update oppsToUpdate;
         */
        Test.stoptest();
    }
   
    Static testmethod void MasterOppClone() {
        test.startTest();        
        TriggerContextUtility.setFirstRunTrue();
        Opportunity opp = [Select Id,Cloning__c from opportunity limit 1];
        opp.cloning__c = true;
        opp.AccountId = null;
        update opp;
        test.stopTest();
    }

    Static testmethod void OppCloneProducts() {
        
        test.startTest();
        Product2 prod =[Select Id, Name from Product2 where Name ='Apex Test' Limit 1];
        Account acc = [Select Id,Name,Type,BillingState from Account where name ='ZZpbest' Limit 1];
        Contact con = [Select Id, Name from Contact where LastName= 'ApexTest' Limit 1];        
        Pricebookentry pbe = [Select Id,Pricebook2Id from Pricebookentry where isactive = true and pricebook2.name = 'VSA Distributor Price List' limit 1];
        
        TriggerContextUtility.setFirstRunTrue();
        
        
        Opportunity oppus = new Opportunity(Name = 'Apex Test',End_User_Lookup_Account__c = acc.Id,Partner_Account_Search__c = acc.id, 
                                            Amount = 2000,CloseDate=Date.today(),StageName='Close Won',Type='New Customer',
                                            Test_Opportunity__c=True,End_User_Contact__c= con.id,
                                            ResellerContact__c = con.id, Product_Name_Main__c = prod.id, Product_Quantity__c=50, Country__c ='United States', ApexTest__c= true   );
        
        insert oppus;
        
        OpportunityLineItem oline = new OpportunityLineItem(PricebookentryID = pbe.Id,
                                                            OpportunityId = oppus.Id,
                                                            Quantity = 10,
                                                            UnitPrice = 300);
        
        insert oline;
        
        Opportunity clone = new Opportunity(Name = 'Apex Test',End_User_Lookup_Account__c = acc.Id,Partner_Account_Search__c = acc.id, 
                                           Amount = 2000,CloseDate=Date.today(),StageName='Distributor SPA Request',Type='New Customer',
                                           Test_Opportunity__c=True,End_User_Contact__c= con.id, Country__c ='Canada',Cloning__c = true,
                                           Product_Sales_Price__c=200,Product_Name_Main__c=prod.id, Product_Quantity__c=50, ApexTest__c= true,
                                           Spa_to_Transfer_to__c = oppus.Id);
        
        insert clone;
        
        
        List<String> pboppid = new List<String>();
        pboppid.add(oppus.Id+','+pbe.Pricebook2Id);
        QuoteNewPriceBook.ChangePB(pboppid);
        test.stopTest();
    }
    
    
}