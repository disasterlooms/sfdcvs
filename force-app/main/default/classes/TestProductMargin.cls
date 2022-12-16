@IsTest
public class TestProductMargin  {
    @testSetup
    private static void BuildTestData(){
        //BuildTestData.AddRecords();
    }
    Static testmethod void TestProductMargin () {
        {
            
            List<Pricebook2> addPb = new List<Pricebook2>();
            PriceBook2 pb = new Pricebook2(Name='VSA Distributor Price List',IsActive=true);
            insert pb;
            
            PriceBook2 pb2 = new Pricebook2(Name='VSA Canadian Price List',IsActive=true);
            insert pb2;
            
            PriceBook2 pb3 = new Pricebook2(Name='VSA CDW Price List',IsActive=true);
            insert pb3;
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
            
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            System.runAs ( thisUser ) {
                
                UserRole r = [Select id from UserRole 
                              where id in (select UserRoleId from user where usertype = 'standard') limit 1];
                //insert r;
                
                User u = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Name = 'SFDC Admin'].Id,
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
                    IsActive = true
                ); 
                
                insert u;
                List<Account> acctsToInsert = new List<Account>();
                List<Contact> consToInsert = new List<Contact>();
                List<User> usersToInsert = new List<User>();
                Contact cmanager = new Contact(FirstName='Random',LastName='ApexTestManager', 
                                               email='apextestmanager@apexmail.com', phone='9995557365', UserID__c =u.Id,AccountId = vs.Id);
                consToInsert.add(cmanager);
                
                Contact csales = new Contact(FirstName='Random',LastName='ApexSalesREp', 
                                             email='apextestsalesrep@apexmail.com', phone='9995557365', UserID__c =u.Id,AccountId = vs.Id);
                consToInsert.add(csales);
                
                Account accz = new Account(Name='ZZpbest', BillingCountryCode ='US',Duplicate_Rule_Suppres__c  = true,BillingStreet='123 main',website = 'ZZpbest.com',BillingCity='citysome',billingPostalCode='73889', BillingState = 'California',Type='End User',Industry= 'Business');
                acctsToInsert.add(accz);
                
                Account accla = new Account(Name='ZZpbest',Duplicate_Rule_Suppres__c  = true, BillingCountryCode ='CO', BillingStreet='123 main',website = 'ZZpbesst.neet',BillingCity='citysome',billingPostalCode='73889',Type='VAR - Latin America',Industry= 'Business');
                acctsToInsert.add(accla);
                
                
                Account accvar = new Account(Name='ZZpbest',Duplicate_Rule_Suppres__c  = true, BillingCountryCode ='US', BillingStreet='123 main',website = 'Zpbesst.orge',BillingCity='citysome',billingPostalCode='73889', BillingState = 'California',Type='VAR',Industry= 'Business');
                acctsToInsert.add(accvar);
                
                Account accedu = new Account(Name='ZZpbest',Duplicate_Rule_Suppres__c  = true, BillingCountryCode ='US',BillingStreet='123 main',website = 'Zpbasfesst.org',Industry='Education',BillingCity='citysome',billingPostalCode='73889',BillingState = 'California',BillingStateCode='CA' ,Type='VAR');
                acctsToInsert.add(accedu);
                
                Account acccdw = new Account(Name='Cdw LLC',Duplicate_Rule_Suppres__c  = true, BillingCountryCode ='US', BillingStreet='123 main',website = 'Zpdadfasfesst.com',BillingCity='citysome',billingPostalCode='73889', BillingState = 'California',Type='NSP',Industry= 'Business');
                acctsToInsert.add(acccdw);
                
                
                Account adistius2 = new Account(Name='usditi', BillingCountryCode ='US', BillingStreet='123 main',BillingCity='citysome',website = 'Zpdadfasfesst.net',billingPostalCode='73889', BillingState = 'California',Type='NSP',Auto_Create_Disti__c=true,Industry= 'Business',Duplicate_Rule_Suppres__c  = true);
                acctsToInsert.add(adistius2);
                
                Account adistius = new Account(Name='usditi', BillingCountryCode ='US', BillingStreet='123 main',BillingCity='citysome',website = 'Zpdadfasfesst.net',billingPostalCode='73889', BillingState = 'California',Type='Distributor',Industry= 'Business',Duplicate_Rule_Suppres__c  = true);
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
                
                
                Account acc = [select id from account where type = 'end user' limit 1];
                
                Opportunity oppObj = new Opportunity(Name = 'TestOpp',AccountID = acc.Id,Amount = 2000,CloseDate=Date.today(),StageName='Close Won',Type='New Customer',Test_Opportunity__c=True);
                insert oppObj;
                
                Product2 newProd = new Product2(Name = 'test product', family = 'test family',List_Price__c=5.00);
                insert newProd;
                
                Opportunity oprod = [select id, pricebook2id from opportunity where id =: oppObj.Id];
                
                PriceBookEntry pbEntry = new PriceBookEntry(
                    UnitPrice = 300,
                    PriceBook2Id = Test.getStandardPricebookId(),
                    Product2Id = newProd.Id,
                    IsActive = true);
                
                insert pbEntry ;
                
                PriceBookEntry pbEntry2 = new PriceBookEntry(
                    UnitPrice = 300,
                    PriceBook2Id = oprod.Pricebook2Id,
                    Product2Id = newProd.Id,
                    IsActive = true);
                
                insert pbEntry2 ;                       
                
                OpportunityLineItem oppLine = new OpportunityLineItem(MarginText__c='50',Approved_Price__c=10,pricebookentryid=pbEntry2.Id,UnitPrice=5,Quantity = 2,OpportunityID = oppObj.Id,z_Apex_Test__c='This is a Test Only 853');
                insert oppLine;
                try {
                    // Query for the opplineitem
                    OpportunityLineItem  oppToUpdate = 
                        [SELECT ID,Approved_Price__c,UnitPrice,Landed_Cost__c,MarginText__c FROM OpportunityLineItem 
                         WHERE z_Apex_Test__c='This is a Test Only 853' 
                         LIMIT 1];
                    
                    // approved price and sales price
                    oppToUpdate.Approved_Price__c= 23;
                    oppToUpdate.UnitPrice=60;
                    oppToUpdate.z_Apex_Test__c='This is a Test Only 853';
                    String s = String.valueOf((oppToUpdate.UnitPrice - oppToUpdate.Landed_Cost__c)/oppToUpdate.UnitPrice*100) ;
                    String t = s.substring(0,4)+'%';
                    oppToUpdate.MarginText__c = t;
                    // Make the update call.
                    update oppToUpdate;
                }
                catch(DmlException e) {
                    System.debug('An unexpected error has occurred: ' + e.getMessage());
                    
                }
                try {
                    // Query for the opplineitem
                    List< Opportunity> oToUpdate = 
                        [SELECT ID FROM Opportunity 
                         WHERE Type='New Customer'
                         LIMIT 1];
                    
                    // approved price and sales price
                    
                    // Make the update call.
                    if(oToUpdate.size() > 0){
                        update oToUpdate;
                    }
                    
                }
                catch(DmlException e) {
                    System.debug('An unexpected error has occurred: ' + e.getMessage());
                    
                }
                try {
                    // Query for the opplineitem
                    OpportunityLineItem  oppToUpdate2 = 
                        [SELECT ID,Approved_Price__c,UnitPrice FROM OpportunityLineItem 
                         WHERE z_Apex_Test__c='This is a Test Only 853' 
                         LIMIT 1];
                    
                    // approved price and sales price
                    oppToUpdate2.Approved_Price__c= 23;
                    oppToUpdate2.UnitPrice=60;
                    // Make the update call.
                    update oppToUpdate2;
                }
                catch(DmlException e) {
                    System.debug('An unexpected error has occurred: ' + e.getMessage());
                    
                }
                
                try {
                    // Query for the opplineitem
                    Product2  prodToUpdate = 
                        [SELECT ID,List_Price__c FROM Product2 
                         WHERE Name = 'test product' 
                         LIMIT 1];
                    
                    
                    // approved price and sales price
                    prodToUpdate.List_Price__c=7.00;
                    
                    // Make the update call.
                    update prodToUpdate;
                }
                catch(DmlException e) {
                    System.debug('An unexpected error has occurred: ' + e.getMessage());
                    
                }
                
            }
        }
    }
}