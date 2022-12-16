@isTest
public class BuildTestData 
{
    public static void AddRecords(){
        // creating some accounts to work with for test data           
        List<Account> acctsToInsert = new List<Account>();
        List<Contact> consToInsert = new List<Contact>();
        List<User> usersToInsert = new List<User>();
        //got to add some single records first...like the viewsonic account        
        
        
        
        //User us =  [Select id, ManagerId from User where isactive = true and ManagerId != :UserInfo.getUserId() limit 1];
        
        User thisUser = [ select Id,ManagerId from User where Id = :UserInfo.getUserId() ];
        
        //thisUser.ManagerId = us.ManagerId;
        //update thisUser;
        List<Profile> prof = [Select id, name from profile where name in ('SFDC Admin','Sales Directors','VSA Sales Directors'
                                                                          ,'Sales - National Reseller','VSA US Sales')];
        Profile admin = new Profile();
        Profile director = new Profile();
        Profile sales = new Profile();
        for(Profile p : prof){
            if(p.name == 'SFDC Admin'){
                admin = p;
            }else if(p.name == 'Sales Directors' || p.name == 'VSA Sales Directors'){
                director = p;
            }else{
                sales = p;
            }
        }
        
        System.runAs ( thisUser ) {
            
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
            insert r;
            
            User u = new User(
                ProfileId = admin.Id,
                LastName = 'last testingapex',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST Apex',
                Title = 'title',
                Country = 'United States',
                Phone = '5625551212',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                UserRoleId = r.Id,
                IsActive = true,
                Sales_Category__c = 'TM'
            ); 
            
            userstoInsert.add(u);
            
            User u2 = new User(
                ProfileId = admin.Id,
                LastName = 'TestUserApex',
                Email = 'pusertest000@amamama.com',
                Username = 'pusertest000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST Apex',
                Title = 'title',
                Country = 'United States',
                Phone = '5625551213',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                UserRoleId = r.Id,
                IsActive = true,
                Sales_Category__c = 'TM'
            ); 
            
            userstoInsert.add(u2);
            
            User umanager = new User(
                ProfileId = director.Id,
                LastName = 'TestUserApexmanager',
                Email = 'directorvs@amamama.com',
                Username = 'directorvs@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST Apex',
                Title = 'title',
                Country = 'United States',
                Phone = '5625551213',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                UserRoleId = r.Id,
                IsActive = true,
                Sales_Category__c = 'Director'
            );             
            userstoInsert.add(umanager);
            
            User usales = new User(
                ProfileId = sales.Id,
                LastName = 'TestsalesApexmanager',
                Email = 'salesvs@amamama.com',
                Username = 'salsvs@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST Apex',
                Title = 'title',
                Country = 'United States',
                Phone = '5625551213',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                UserRoleId = r.Id,
                IsActive = true,
                Sales_Category__c = 'Sales - National'
            );             
            userstoInsert.add(usales);
            TriggerContextUtility.setFirstRunFalse();
            insert  userstoInsert;

            Account vs = new Account (Name ='ViewSonic Corporation',
                                      BillingStreet = '10 Point Dr',
                                      BillingCity ='Brea',
                                      BillingCountryCode ='US',
                                      BillingPostalCode ='93546',
                                      BillingStateCode = 'CA',
                                      Industry= 'Business',
                                      website = 'business.comm',
                                      Type = 'End User',
                                      Apex_Test__c = true,
                                      Duplicate_Rule_Suppres__c  = true);
            TriggerContextUtility.setFirstRunFalse();
            insert vs;
            Pricebook2 standardPricebook = new Pricebook2(
                Id = Test.getStandardPricebookId(),
                IsActive = true
            );
            update standardPricebook;
            
            List<Pricebook2> stnPricebook = [Select id,name from pricebook2 where id = :  Test.getStandardPricebookId()];
             system.debug('stnPricebook');
            system.debug(stnPricebook);
            
            Contact cmanager = new Contact(FirstName='Random',LastName='ApexTestManager', 
                                           email='apextestmanager@apexmail.com', phone='9995557365', UserID__c =umanager.Id,AccountId = vs.Id);
            consToInsert.add(cmanager);
            
            Contact csales = new Contact(FirstName='Random',LastName='ApexSalesREp', 
                                         email='apextestsalesrep@apexmail.com', phone='9995557365', UserID__c =umanager.Id,AccountId = vs.Id);
            consToInsert.add(csales);
            
            umanager.Contact_ID__c = cmanager.Id;
            
            Account acc = new Account(Name='ZZpbest', BillingCountryCode ='US',Duplicate_Rule_Suppres__c  = true,BillingStreet='123 main',website = 'ZZpbest.com',BillingCity='citysome',billingPostalCode='73889', BillingState = 'California',Type='End User',Industry= 'Business');
            acctsToInsert.add(acc);
            
            Account accla = new Account(Name='ZZpbest',Duplicate_Rule_Suppres__c  = true, BillingCountryCode ='CO', BillingStreet='123 main',website = 'ZZpbesst.neet',BillingCity='citysome',billingPostalCode='73889',Type='VAR',Industry= 'Business');
            acctsToInsert.add(accla);
            
            
            Account accvar = new Account(Name='ZZpbest',Duplicate_Rule_Suppres__c  = true, BillingCountryCode ='US', BillingStreet='123 main',website = 'Zpbesst.orge',BillingCity='citysome',billingPostalCode='73889', BillingState = 'California',Type='VAR',Industry= 'Business');
            acctsToInsert.add(accvar);
            
            Account acceduEU = new Account(Name='ZZpbestEDdausidfhas',Duplicate_Rule_Suppres__c  = true, BillingCountryCode ='US',BillingStreet='123 main afasef',
                                           website = 'Zpbaasdfasdfasdfasfdsfesst.org',Industry='Education',BillingCity='citydfasdfasdfsome',billingPostalCode='7382342342389',BillingStateCode='CA' ,Type ='End User');
            acctsToInsert.add(acceduEU);
            
            Account accedu = new Account(Name='ZZpbest',Duplicate_Rule_Suppres__c  = true, BillingCountryCode ='US',BillingStreet='123 main',website = 'Zpbasfesst.org',Industry='Education',BillingCity='citysome',billingPostalCode='73889',BillingState = 'California',BillingStateCode='CA' ,Type ='VAR');
            acctsToInsert.add(accedu);
            
            Account acccdw = new Account(Name='Cdw LLC',Duplicate_Rule_Suppres__c  = true, BillingCountryCode ='US', BillingStreet='123 main',website = 'Zpdadfasfesst.com',BillingCity='citysome',billingPostalCode='73889', BillingState = 'California',Type='NSP',Industry= 'Business');
            acctsToInsert.add(acccdw);
            
            
            Account adistius2 = new Account(Name='usditi', BillingCountryCode ='US', BillingStreet='123 main',
                                            BillingCity='citysome',website = 'Zpdadfasfesst.net',billingPostalCode='73889', BillingState = 'California',Type='NSP',Auto_Create_Disti__c=true,Industry= 'Business',Duplicate_Rule_Suppres__c  = true);
            acctsToInsert.add(adistius2);
            
            Account adistius = new Account(Name='usditi', BillingCountryCode ='US', BillingStreet='123 main',
                                           BillingCity='citysome',website = 'Zpdadfasfesst.net',billingPostalCode='73889', Auto_Create_Disti__c=true,
                                           BillingState = 'California',Type='Distributor',Industry= 'Business',Duplicate_Rule_Suppres__c  = true);
            acctsToInsert.add(adistius);
            
            
            Account adistican = new Account(Name='canadadisit',BillingCountryCode ='CA', BillingStreet='123 main',BillingCity='citysome',website = 'Zsfesst.organ',billingPostalCode='73889', BillingState = 'Alberta', Type='NSP',Auto_Create_Disti__c=true,Duplicate_Rule_Suppres__c  = true,Industry= 'Business');
            acctsToInsert.add(adistican);
            
            Account edu = new Account(Name='educationaccount',BillingCountryCode ='US', BillingStreet='123 main',BillingCity='citysome',website = 'Zsasfasdffesst.commie' ,billingPostalCode='73889', BillingState = 'California',Type='End User',Duplicate_Rule_Suppres__c  = true,Industry ='Education');
            acctsToInsert.add(edu);
            TriggerContextUtility.setFirstRunFalse();
            insert acctsToInsert;
            
            Contact coneval = new Contact(LastName='tonythetester', email='testemailtony@testingcenter.com',AccountID =accedu.Id);
            consToInsert.add(coneval);
            
            Contact convseval = new Contact(LastName='tonythetester', email='testemailtony@testingcenter.com',AccountID =accedu.Id,UserID__c= UserInfo.getUserId());
            consToInsert.add(convseval);
            
            Contact con = new Contact(FirstName='Random',LastName='ApexTest', email='apextest@apexmail.com', phone='9995557365', AccountID =accla.Id);
            consToInsert.add(con);
            
            Contact convar = new Contact(FirstName='Random',LastName='ApexTest', email='apextest@apexmail.com', phone='9995557365', AccountID =accvar.Id);
            consToInsert.add(convar);
            TriggerContextUtility.setFirstRunFalse();
            insert consToInsert;
            
            List<AccountTeamMember> aTeams = new List<AccountTeamMember>();
            
            AccountTeamMember acctteam = new AccountTeamMember(AccountId = acc.Id,  TeamMemberRole='Distributor',
                                                               AccountAccessLevel='Edit',
                                                               CaseAccessLevel='Edit',
                                                               ContactAccessLevel ='Edit',
                                                               OpportunityAccessLevel='Edit',
                                                               userid=u.id);
            aTeams.add(acctteam) ;
            
            AccountTeamMember acctteamus = new AccountTeamMember(AccountId = adistius.Id,  TeamMemberRole='Distributor',
                                                                 AccountAccessLevel='Edit',
                                                                 CaseAccessLevel='Edit',
                                                                 ContactAccessLevel ='Edit',
                                                                 OpportunityAccessLevel='Edit',
                                                                 userid=u.id);
           
            aTeams.add(acctteamus);
            
            AccountTeamMember acctteamcan = new AccountTeamMember(AccountId = adistican.Id,  TeamMemberRole='Distributor',
                                                                  AccountAccessLevel='Edit',
                                                                  CaseAccessLevel='Edit',
                                                                  ContactAccessLevel ='Edit',
                                                                  OpportunityAccessLevel='Edit',
                                                                 userid=u.id);
             aTeams.add(acctteamcan);
            
            AccountTeamMember acctteamcdw = new AccountTeamMember(AccountId = acccdw.Id,  TeamMemberRole='Distributor',
                                                                  AccountAccessLevel='Edit',
                                                                  CaseAccessLevel='Edit',
                                                                  ContactAccessLevel ='Edit',
                                                                  OpportunityAccessLevel='Edit',
                                                                  userid=u.id);
            
            aTeams.add(acctteamcdw);
            TriggerContextUtility.setFirstRunFalse();
            insert aTeams;
            List<Product2> products = new List<Product2>();
            
            Product2 prod = new Product2(Name = 'Apex Test', family = 'test family',List_Price__c=5.00, IsActive= true);
            products.add(prod);
            
            Product2 prod1 = new Product2(Name = 'Apex Test1', family = 'test family',List_Price__c=5.00, IsActive= true);
            products.add(prod1);
            
            Product2 prodifp = new Product2(Name = 'IFP652484', family = 'test family',List_Price__c=5.00, IsActive= true);
            products.add(prodifp);
            
            insert products;
            
            Accessories__c access = new Accessories__c(Name = prod1.Name,Accessory_Product__c = prod.id,Main_Product__c = prod1.id );
            insert access;                
            
            List<PriceBook2> pricebooks = new List<PriceBook2>();
            
            PriceBook2 pb = new Pricebook2(Name='VSA Distributor Price List',IsActive=true,currencyIsoCode__c = 'USD');
            pricebooks.add(pb);
            
            PriceBook2 pb2 = new Pricebook2(Name='VSA Canadian Price List',IsActive=true,currencyIsoCode__c = 'USD');
            pricebooks.add(pb2);
            
            PriceBook2 pb3 = new Pricebook2(Name='VSA CDW Price List',IsActive=true,currencyIsoCode__c = 'USD');
            pricebooks.add(pb3);
            
            insert pricebooks;
            
            List<PriceBookEntry> pbentries = new List<PriceBookEntry>();
            
            PriceBookEntry pbEntry = new PriceBookEntry(
                UnitPrice = 300,
                PriceBook2Id = Test.getStandardPricebookId() ,
                Product2Id = prod.Id,
                IsActive = true);
            
            PriceBookEntry pbEntry1 = new PriceBookEntry(
                UnitPrice = 300,
                PriceBook2Id = pb.Id,
                Product2Id = prod.Id,
                IsActive = true);
            
            PriceBookEntry pbEntry2 = new PriceBookEntry(
                UnitPrice = 300,
                PriceBook2Id = pb2.Id,
                Product2Id = prod.Id,
                IsActive = true);
            
            
            PriceBookEntry pbEntry3 = new PriceBookEntry(
                UnitPrice = 300,
                PriceBook2Id = pb3.Id,
                Product2Id = prod.Id,
                IsActive = true);
            
            pbentries.add(pbEntry);
            pbentries.add(pbEntry1);
            pbentries.add(pbEntry2);
            pbentries.add(pbEntry3);
            
            database.insert (pbentries,false);
            
            TriggerContextUtility.setFirstRunFalse();
            
            //insert opps as a list and create some opportunities
            List<Opportunity> oppsToInsert = new List<Opportunity>();
            
            
            Opportunity opp = new Opportunity(Name = 'Apex Test',End_User_Lookup_Account__c = acc.Id,Partner_Account_Search__c = acc.id, 
                                              Amount = 2000,CloseDate=Date.today(),StageName='Close Won',Type='New Customer',Country__c='United States',
                                              Test_Opportunity__c=True,End_User_Contact__c= con.id,Pricebook2Id = pb.Id,
                                              ResellerContact__c = con.id, Product_Name_Main__c = prod.id, Product_Quantity__c=50, ApexTest__c= true  );
            
            oppsToInsert.add(opp);
            
            Opportunity opptoup = new Opportunity(Name = 'opptoupdate',End_User_Lookup_Account__c = acc.Id,Partner_Account_Search__c = acc.id, 
                                                  Amount = 2000,CloseDate=Date.today(),StageName='Distributor SPA Request',Type='New Customer',
                                                  Test_Opportunity__c=True,End_User_Contact__c= con.id, Country__c ='Canada',
                                                  Product_Sales_Price__c=200,Product_Name_Main__c=prod.id, Product_Quantity__c=50, ApexTest__c= true );
            
            
            oppsToInsert.add(opptoup);
            
            Opportunity oppedu = new Opportunity(Name = 'Apex Testedu',End_User_Lookup_Account__c = acc.Id,Partner_Account_Search__c = acc.id, 
                                                 Amount = 2000,CloseDate=Date.today()+90,StageName='Price Quote',Type='New Customer',Country__c='United States',
                                                 Test_Opportunity__c=True,End_User_Contact__c= con.id,
                                                 ResellerContact__c = con.id, Product_Name_Main__c = prod.id, Product_Quantity__c=50, ApexTest__c= true  );
            oppsToInsert.add(oppedu);
            
            Opportunity oppeval = new Opportunity(Name = 'Apex Testeval',End_User_Lookup_Account__c = acc.Id,Partner_Account_Search__c = acc.id, 
                                                  Amount = 2000,CloseDate=Date.today()+90,StageName='Interest',Type='New Customer',Country__c='United States',
                                                  Test_Opportunity__c=True,End_User_Contact__c= con.id,
                                                  ResellerContact__c = con.id, Product_Name_Main__c = prod.id, Product_Quantity__c=50, ApexTest__c= true  );
            oppsToInsert.add(oppeval);
            
            
            Opportunity onores = new Opportunity(Name = 'Apex Testeval', 
                                                 Amount = 2000,CloseDate=Date.today()+90,StageName='Interest',Type='New Customer',Country__c='United States',
                                                 Test_Opportunity__c=True, ApexTest__c= true);
            
            oppsToInsert.add(onores);
            
            Opportunity disti = new Opportunity(Name = 'Apex Testeval', End_User_Lookup_Account__c = acc.Id,
                                                Amount = 2000,CloseDate=Date.today()+90,StageName='Distributor SPA Request',Type='New Customer',Country__c='United States',
                                                Test_Opportunity__c=True, ApexTest__c= true);
            
            oppsToInsert.add(disti);
            
            //insert oppsToInsert
           
            
            database.insert (oppsToInsert,true);
            
            Quote q = new Quote(name='apext test',
                                OpportunityId = opp.Id,
                                pricebook2Id = opp.Pricebook2Id);
            
             TriggerContextUtility.setFirstRunFalse();
             insert q;
            
            Contact_Role__c conrole = new Contact_Role__c(Opportunity__c = opp.Id,Contact__c = con.Id, Role__c = 'End User Contact');
            //insert conrole;
            
            OpportunityContactRole conrol = new OpportunityContactRole();
            conrol.OpportunityId = opp.Id;
            conrol.ContactId = con.Id;
            insert conrol;
            List <OpportunityLineItem> newlines = new List<OpportunityLineItem>();
            
            OpportunityLineItem newline = new OpportunityLineItem(PriceBookEntryId = pbEntry1.Id,
                                                                  UnitPrice = 100,
                                                                  Quantity = 100,
                                                                  OpportunityId = opp.Id);
            
            newlines.add(newline);
            
            OpportunityLineItem distiline = new OpportunityLineItem(PriceBookEntryId = pbEntry1.Id,
                                                                    UnitPrice = 100,
                                                                    Quantity = 100,
                                                                    OpportunityId = disti.Id);
            
            newlines.add(distiline);
            
            
            TriggerContextUtility.setFirstRunFalse();
            insert newlines;
            
            List<Campaign> campaigns = new List<Campaign>();
            
            Campaign camp2 = new Campaign(
                Name= 'Customer Service Incoming Call',
                Status = 'In Progress',
                IsActive=true             
            ); 
            campaigns.add(camp2);
            
            Campaign camp = new Campaign(Name = 'Some Cool Test Campaign',
                                         IsActive = true,
                                         Status = 'In Progress');
            
            campaigns.add(camp);
            TriggerContextUtility.setFirstRunFalse();
            insert campaigns;
            
            CampaignMember memb = new CampaignMember(CampaignId = camp.Id,
                                                     ContactId = con.Id,
                                                     Status = 'In Progress');
            TriggerContextUtility.setFirstRunFalse();
            insert memb;
            
            Eval_Request__c ev = new Eval_Request__c(
                Expected_Receive_Date__c= date.today(),
                //Evaluation_Owner__c = csales.id,
                Billing_Contact_Name__c = coneval.Id             
            ); 
            database.insert(ev, false);
            system.debug(con.name);
            //insert ev;
            
            List<Eval_Unit_Details__c> evs = new List<Eval_Unit_Details__c>();
            
            Eval_Unit_Details__c eu1 = new Eval_Unit_Details__c(
                Eval_Request__c= ev.Id,
                SKU__c = prod.id,
                Name='1521841545'             
            ); 
            evs.add( eu1);
            
            Eval_Unit_Details__c eu2 = new Eval_Unit_Details__c(
                Eval_Request__c= ev.Id,
                SKU__c = prod.id,
                Name='18548415487'             
            ); 
            TriggerContextUtility.setFirstRunFalse();
             evs.add( eu2);            
            database.insert( evs,false);
            
            //Quota__c qt =  new Quota__c (Sales_Rep__c = UserInfo.getUserId());
            //insert qt;
            
            
            //Product_Manager__c pilar = new Product_Manager__c (Name = 'Monitors');
            //insert pilar;
            
            Modal__c md = new Modal__c ();
            md.name = 'test modal';
            md.isActive__c = true; 
            md.Content__c = 'some content';
            insert md;
            
            Modal_Settings__c ms = new Modal_Settings__c ();
            ms.Modal__c = md.Id;
            ms.User__c = u.Id;
            ms.Last_Date_Shown__c = date.today();
            insert ms;
            
            
           //Opportunity oppq = [Select id, spa_Id__c from opportunity where id = : opp.Id ];
            
            /*
            Quote q1 = new Quote();
            q1.OpportunityId = oppq.Id;
            q1.Name = oppq.spa_Id__c;
            TriggerContextUtility.setFirstRunFalse(); */
            //insert q1;
            
            Quote qte = [Select id,OpportunityId,opportunity.AccountId,AccountId,Name from Quote where id =: q.Id limit 1];
            
            //Account a = [Select id from account where id = : qte.AccountId limit 1];
            system.debug('Quote info '+qte.Name +' '+qte.OpportunityId+' '+qte.AccountId);
            
            Order o = new Order();
            o.Status = 'Draft';
            o.Contact_Name__c = 'john';
            o.Named_Location_of_Training__c  = 'testing';
            System.debug('Order Account ID'+acc.id);
            o.AccountId = acc.id;//qte.Opportunity.AccountId;
            o.EffectiveDate = date.today();
            o.SpaNumber__c = qte.Name;
            TriggerContextUtility.setFirstRunFalse();
            insert o;
            
            List<Spiff_request__c> spiffsToInsert = new List<Spiff_request__c>();
            
            Spiff_request__c spiffr = new Spiff_request__c();
            spiffr.End_User__c = accedu.Id;    
            spiffr.Product__c= prodifp.Id;
            spiffr.Distributor__c = adistius.Id;
            spiffr.Requester_Company__c = accvar.Id;
            spiffr.End_User_Contact_Name__c  = csales.FirstName;
            spiffr.End_User_Contact_Last_Name__c  = csales.LastName;
            spiffr.End_User_Email__c   = 'somefakeeamild@masidfoa.com';
            spiffr.Sale_Date__c = date.today();
            spiffr.Quantity__c  = 1;
            spiffr.Requester__c = cmanager.Id;
            
            spiffsToInsert.add(spiffr);
            
            Spiff_request__c spiffrNoAcct = new Spiff_request__c();
            spiffrNoAcct.End_User__c = accedu.Id;    
            spiffrNoAcct.Product__c= prodifp.Id;
            spiffrNoAcct.Distributor__c = adistius.Id;
            spiffrNoAcct.End_User_Contact_Name__c  = csales.FirstName;
            spiffrNoAcct.End_User_Contact_Last_Name__c  = csales.LastName;
            spiffrNoAcct.End_User_Email__c   = 'somefakeeamild@masidfoa.com';
            spiffrNoAcct.Sale_Date__c = date.today();
            spiffrNoAcct.Quantity__c  = 1;
            spiffrNoAcct.Requester__c = cmanager.Id;
            
            spiffsToInsert.add(spiffrNoAcct);
            
            
            Spiff_request__c spiffr2 = new Spiff_request__c();
            spiffr2.End_User__c = accedu.Id;    
            spiffr2.Product__c= prodifp.Id;
            spiffr2.Distributor__c = adistius.Id;
            spiffr2.Requester_Company__c = accvar.Id;
            spiffr2.End_User_Contact_Name__c  = csales.FirstName;
            spiffr2.End_User_Contact_Last_Name__c  = csales.LastName;
            spiffr2.End_User_Email__c   = csales.Email;
            spiffr2.Sale_Date__c = date.today();
            spiffr2.Quantity__c  = 1;
            spiffr2.Requester__c = cmanager.Id;
            
            spiffsToInsert.add(spiffr2);
            PricingEffectiveDate__c pe = new PricingEffectiveDate__c();
            pe.name = 'PricingDate';
            pe.Effective_Date__c = date.today();
            TriggerContextUtility.setFirstRunFalse();
            insert pe;    
            
            TriggerContextUtility.setFirstRunFalse();
            insert spiffsToInsert;
            
            List<CountriesRegions__c> cRegions = new List <CountriesRegions__c>();
            CountriesRegions__c regionUS = new CountriesRegions__c();
            CountriesRegions__c regionUK = new CountriesRegions__c();
            regionUS.Country__c = 'United States';
            regionUS.CountryCode__c  = 'US';
            regionUS.VSRegion__c = 'VSA';
            regionUK.Country__c = 'United Kingdom';
            regionUK.CountryCode__c  = 'GB';
            regionUK.VSRegion__c = 'VSE';
            cRegions.add(regionUS);
            cRegions.add(regionUK);
            TriggerContextUtility.setFirstRunFalse();
            insert cRegions;
        }    
    }
}