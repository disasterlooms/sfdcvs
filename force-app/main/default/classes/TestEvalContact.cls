@IsTest
public class TestEvalContact {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void TestEvalContact () {
        {
            List<Opportunity> opps = [SELECT ID,Name FROM Opportunity WHERE Name = 'Viewsonic Sales Rep Evaluations' LIMIT 1];
            List<Opportunity> opps1 = [SELECT ID,Name FROM Opportunity WHERE Name = 'Viewsonic Trade Show Loaner Eval Requests' LIMIT 1];
            
            Account acc = [Select Id from account where name ='ViewSonic Corporation' limit 1];
            
            Contact cont1 = new Contact(LastName= 'Admin',MailingCountry='United States', email='apextest3@apexmail.com',AccountId = acc.Id);
            insert cont1;
            //Contact cont = [Select Past_Due__c,PR_Outstanding_Evals_EU_Disty__c,PR_Past_Due_Evals__c,PR_Write_offs_Last_12_Months__c FROM Contact Where LastName= 'Admin' LIMIT 1];
            Profile p = [SELECT Id FROM Profile WHERE Name='SFDC Admin']; 
            User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com', 
                               EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorgviewsonic.com', Contact_ID__c = cont1.id, Country =
                               'United States');  
            
            System.runAs(u2) {        
                
                Test.startTest();
                // set the test's page to your VF page
                Test.setCurrentPage(Page.ProductRequest);
                
                
                PriceBook2 pb = new Pricebook2(Name='VSA Distributor Price List',IsActive=true);
                insert pb;
                
                PriceBook2 pb2 = new Pricebook2(Name='VSA Canadian Price List',IsActive=true);
                insert pb2;
                
                PriceBook2 pb3 = new Pricebook2(Name='VSA CDW Price List',IsActive=true);
                insert pb3;
                
                
                
                Product2 newProd = new Product2(Name = 'test product', family = 'test family',List_Price__c=5.00);
                insert newProd; 
                
                Product2 newProd2 = new Product2(Name = 'test product', family = 'test family',List_Price__c=5.00);
                insert newProd2;
                
                Product2 newProd3 = new Product2(Name = 'test product', family = 'test family',List_Price__c=5.00);
                insert newProd3;
                
                Product2 newProd4 = new Product2(Name = 'test product', family = 'test family',List_Price__c=5.00);
                insert newProd4;
                
                Product2 newProd5 = new Product2(Name = 'test product', family = 'test family',List_Price__c=5.00);
                insert newProd5;
                
                
               
                TriggerContextUtility.setFirstRunFalse();
                
                
                List<Account> acctsToInsert = new List<Account>();
                
                
                Account acc2 = new Account(Name='bestnewevalopp',BillingStreet='123 main',BillingCity='citysomewehre',BillingPostalCode='73889',BillingState = 'zz' ,Type='End User',website = 'somerandmoeweb.mccom');
                acctsToInsert.add(acc2);
                
                
                //insert acctsToInsert;
                //Create Opportunity 1
                
                
                List<Opportunity> oppsToInsert = new List<Opportunity>();
                
                Opportunity oppObj = new Opportunity(Name = 'TestOpp',AccountID = acc2.Id,Amount = 2000,CloseDate=Date.today(),StageName='Close Won',Type='New Customer',Test_Opportunity__c=True);
                oppsToInsert.add(oppObj);
                
                
                
                Opportunity oppObj2 = new Opportunity(Name = 'TestOpp',AccountID = acc2.Id,Amount = 2000,CloseDate=Date.today(),StageName='Close Won',Type='New Customer',Test_Opportunity__c=True);
                oppsToInsert.add(oppObj2);
                
                Opportunity oppObj3 = new Opportunity(Name = 'TestOpp',AccountID = acc2.Id,Amount = 2000,CloseDate=Date.today(),StageName='Close Won',Type='New Customer',Test_Opportunity__c=True);
                oppsToInsert.add(oppObj3);
                
                
                Opportunity oppObj4 = new Opportunity(Name = 'TestOpp',AccountID = acc2.Id,Amount = 2000,CloseDate=Date.today(),StageName='Close Won',Type='New Customer',Test_Opportunity__c=True);
                oppsToInsert.add(oppObj4);
                
                Opportunity oppObj5 = new Opportunity(Name = 'TestOpp',AccountID = acc2.Id,Amount = 2000,CloseDate=Date.today(),StageName='Close Won',Type='New Customer',Test_Opportunity__c=True);
                oppsToInsert.add(oppObj5);
                
                insert oppsToInsert;
                
                List< PriceBookEntry> pbeInsert = new List <PriceBookEntry>();
                
                PriceBookEntry pbEntry = new PriceBookEntry(
                    UnitPrice = 300,
                    PriceBook2Id = Test.getStandardPricebookId(),
                    Product2Id = newProd.Id,
                    IsActive = true);
                
                 pbeInsert.add(pbEntry);
                
                PriceBookEntry pbEntry2 = new PriceBookEntry(
                    UnitPrice = 300,
                    PriceBook2Id = Test.getStandardPricebookId(),
                    Product2Id = newProd2.Id,
                    IsActive = true);
                
                pbeInsert.add(pbEntry2) ;
                
                 Opportunity op = [Select Id, Pricebook2Id from Opportunity where id =: oppObj.Id limit 1];
                
                PriceBookEntry pbEntry3 = new PriceBookEntry(
                    UnitPrice = 300,
                    PriceBook2Id = op.Pricebook2Id,
                    Product2Id = newProd.Id,
                    IsActive = true);
                
                 pbeInsert.add(pbEntry3);
                
                PriceBookEntry pbEntry4 = new PriceBookEntry(
                    UnitPrice = 300,
                    PriceBook2Id = op.Pricebook2Id,
                    Product2Id = newProd2.Id,
                    IsActive = true);
                
                pbeInsert.add(pbEntry4);
                
                insert  pbeInsert;
                
                
                //Create 5 Opp line products to transfer to eval request
                
                
                List<OpportunityLineItem> lineitemsToInsert = new List<OpportunityLineItem>();
                
                OpportunityLineItem oppLine = new OpportunityLineItem(Evaluation_Product__c = True,pricebookentryid=pbEntry3.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj.Id,z_Apex_Test__c='This is a Test Only 853');
                lineitemsToInsert.add(oppLine);
                
                OpportunityLineItem oppLine2 = new OpportunityLineItem(Evaluation_Product__c = True,pricebookentryid=pbEntry3.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj.Id,z_Apex_Test__c='This is a Test Only 853');
                lineitemsToInsert.add(oppLine2);
                
                OpportunityLineItem oppLine3 = new OpportunityLineItem(Evaluation_Product__c = True,pricebookentryid=pbEntry3.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj.Id,z_Apex_Test__c='This is a Test Only 853');
                lineitemsToInsert.add(oppLine3);
                
                OpportunityLineItem oppLine4 = new OpportunityLineItem(Evaluation_Product__c = True,pricebookentryid=pbEntry4.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj.Id,z_Apex_Test__c='This is a Test Only 853');
                lineitemsToInsert.add(oppLine4);
                
                OpportunityLineItem oppLine5 = new OpportunityLineItem(Evaluation_Product__c = True,pricebookentryid=pbEntry4.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj.Id,z_Apex_Test__c='This is a Test Only 853');
                lineitemsToInsert.add(oppLine5);
                
                
                //create 2nd opp with 4 oppline items to test the change in list size
                
                
                
                OpportunityLineItem oppLine6 = new OpportunityLineItem(Evaluation_Product__c = True,pricebookentryid=pbEntry3.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj2.Id,z_Apex_Test__c='This is a Test Only 853');
                lineitemsToInsert.add(oppLine6);
                
                OpportunityLineItem oppLine7 = new OpportunityLineItem(Evaluation_Product__c = True,pricebookentryid=pbEntry4.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj2.Id,z_Apex_Test__c='This is a Test Only 853');
                lineitemsToInsert.add(oppLine7);
                
                OpportunityLineItem oppLine8 = new OpportunityLineItem(Evaluation_Product__c = True,pricebookentryid=pbEntry4.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj2.Id,z_Apex_Test__c='This is a Test Only 853');
                lineitemsToInsert.add(oppLine8);
                
                OpportunityLineItem oppLine9 = new OpportunityLineItem(Evaluation_Product__c = True,pricebookentryid=pbEntry3.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj2.Id,z_Apex_Test__c='This is a Test Only 853');
                lineitemsToInsert.add(oppLine9);
                
                //create 3rd opp with 3 oppline items to test the change in list size
                
                
                
                OpportunityLineItem oppLine10 = new OpportunityLineItem(Evaluation_Product__c = True,pricebookentryid=pbEntry3.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj3.Id,z_Apex_Test__c='This is a Test Only 853');
                lineitemsToInsert.add(oppLine10);
                
                OpportunityLineItem oppLine11 = new OpportunityLineItem(Evaluation_Product__c = True,pricebookentryid=pbEntry3.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj3.Id,z_Apex_Test__c='This is a Test Only 853');
                lineitemsToInsert.add(oppLine11);
                
                OpportunityLineItem oppLine12 = new OpportunityLineItem(Evaluation_Product__c = True,pricebookentryid=pbEntry3.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj3.Id,z_Apex_Test__c='This is a Test Only 853');
                lineitemsToInsert.add(oppLine12);
                
                //create 4th opp with 2 oppline items to test the change in list size
                
                
                
                OpportunityLineItem oppLine13= new OpportunityLineItem(Evaluation_Product__c = True,pricebookentryid=pbEntry3.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj4.Id,z_Apex_Test__c='This is a Test Only 853');
                lineitemsToInsert.add(oppLine13);
                
                OpportunityLineItem 
                    oppLine14 = new OpportunityLineItem(Evaluation_Product__c = True,pricebookentryid=pbEntry3.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj4.Id,z_Apex_Test__c='This is a Test Only 853');
                lineitemsToInsert.add(oppLine14);
                
                //create 5th opp with 1 oppline items to test the change in list size
                
                
                
                OpportunityLineItem oppLine15= new OpportunityLineItem(Evaluation_Product__c = True,pricebookentryid=pbEntry3.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj5.Id,z_Apex_Test__c='This is a Test Only 853');
                lineitemsToInsert.add(oppLine15);
                
                insert lineitemsToInsert;
                
                
                // call the constructor with with 5 oppline items
                System.currentPageReference().getParameters().put('CF00NA000000AJjZv_lkid', oppObj.Id);
                
                EvalContact controller = new EvalContact(new ApexPages.StandardController(new Eval_Request__c ()));
                
                // call the constructor again with with 4 oppline items
                
                System.currentPageReference().getParameters().put('CF00NA000000AJjZv_lkid', oppObj2.Id);
                
                EvalContact controller2 = new EvalContact(new ApexPages.StandardController(new Eval_Request__c ()));
                
                /// call the constructor again with with 3 oppline items
                
                System.currentPageReference().getParameters().put('CF00NA000000AJjZv_lkid', oppObj3.Id);
                
                EvalContact controller3 = new EvalContact(new ApexPages.StandardController(new Eval_Request__c ()));
                
                /// call the constructor again with 2 oppline items
                
                System.currentPageReference().getParameters().put('CF00NA000000AJjZv_lkid', oppObj4.Id);
                
                EvalContact controller4 = new EvalContact(new ApexPages.StandardController(new Eval_Request__c ()));
                
                /// call the constructor again with 1 oppline items
                
                System.currentPageReference().getParameters().put('CF00NA000000AJjZv_lkid', oppObj5.Id);
                
                EvalContact controller5 = new EvalContact(new ApexPages.StandardController(new Eval_Request__c ()));     
                
                // stop the test
                Test.stopTest();
            }
        }
    }
}