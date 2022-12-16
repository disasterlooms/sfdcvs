global class SandboxRecords implements SandboxPostCopy {
    global void runApexClass(SandboxContext context) {
        /*
         * Commenting out since this has errors and cannot run and 
         * there is now a partial and full sandbox to test with
         * jason orbison 9/3/2021
         * 
        System.debug('Hello Tester Pester ' + context.organizationId()
                     + ' ' + context.sandboxId() + context.sandboxName());
        
        RecordType rt  = [Select Id, Name from RecordType where name = 'Viewsonic' limit 1];
        
        
        Account a = new Account (Name ='ViewSonic Corporation',
                                 BillingStreet = '10 Point Dr',
                                 BillingCity ='Brea', 
                                 Phone = '(909) 444-8700',
                                 BillingPostalCode ='93546',
                                 BillingState = 'CA',
                                 Type = 'End User', 
                                 RecordTypeId= rt.Id);
        
        database.insert(a,false);
        
        //updating users in sandbox to associate with newly created
        //viewsonic account so that the customized quick create
        //work for all layouts 
        
        Contact conpm = new Contact(FirstName = 'Product', LastName='Manager', Email= 'pm@viewsonic.com', AccountId= a.id, Apex_Test__c = true);
        insert conpm;
        
        Product_Manager__c pm = new Product_Manager__c(
            Name='Some Product Pillar', 
            Product_Manager__c = conpm.Id);
        insert pm;
        
        List<Product2> prodstoInsert = new List<Product2>();
        
        List<Product2> products = [SELECT Id,Name,Product_Line__c FROM Product2 ];
        
        for (Product2  prod : products){
            
            prod.Product_Line__c = pm.id;
            
            prodstoInsert.add(prod);
            
        }
        
        database.update(prodstoInsert, false);
        
        
        List<Account> accs = new List<Account>();
        
        
        Account a4 = new Account (Name ='Ingram Micro',
                                  BillingCountry = 'United States',
                                  Type = 'Distributor',
                                  BillingCity='Pasadena',
                                  BillingState = 'CA',
                                  Auto_Create_Disti__c = true,
                                  industry='Business'); 
        
        accs.add(a4);
        
        Account a1 = new Account (Name ='TechData Corp',
                                  BillingCountry = 'United States',
                                  Type = 'Distributor',
                                  BillingCity='Tampa',
                                  BillingState = 'CA',
                                  Auto_Create_Disti__c = true,
                                  industry='Business');         
        accs.add(a1);
        
        Account a2 = new Account (Name ='Synnex',
                                  BillingCountry = 'United States',
                                  Type = 'Distributor',
                                  BillingCity='Raleigh',
                                  BillingState = 'CA',
                                  Auto_Create_Disti__c = true,
                                  industry='Business');         
        accs.add(a2);
        
        Account a3 = new Account (Name ='ASI',
                                  BillingCountry = 'United States',
                                  Type = 'Distributor',
                                  BillingCity='Pheonix',
                                  BillingState = 'CA',
                                  Auto_Create_Disti__c = true,
                                  industry='Business');         
        accs.add(a3);
        
        Account a5 = new Account (Name ='CDW LLC',
                                  BillingCountry = 'United States',
                                  BillingCity='Chicago',
                                  BillingState = 'CA',
                                  Type = 'NSP',
                                  industry='Business');         
        accs.add(a5);
        
        Account a6 = new Account (Name ='ASI Canada',
                                  BillingCountry = 'Canada',
                                  Type = 'Distributor',
                                  BillingState = 'CA',
                                  BillingCity='New Brunswick',
                                  Auto_Create_Disti__c = true,
                                  industry='Business');         
        accs.add(a6);
        
        Account a7 = new Account (Name ='Ingram Canada',
                                  BillingCountry = 'Canada',
                                  BillingCity='Toronto',
                                  Type = 'Distributor',
                                  BillingState = 'AB',
                                  Auto_Create_Disti__c = true,
                                  industry='Business');         
        accs.add(a7);
        
        Account a8 = new Account (Name ='Tech Canada',
                                  BillingCountry = 'Canada',
                                  BillingState = 'AB',
                                  BillingCity='Toronto',
                                  Type = 'Distributor',
                                  Auto_Create_Disti__c = true,
                                  industry='Business');         
        accs.add(a8);
        Account ares = new Account (Name ='Sandbox Reseller',
                                    BillingCountry = 'United States',
                                    BillingState = 'CA',
                                    BillingCity='reseller',
                                    Type = 'VAR',
                                    industry='Business');         
        accs.add(ares);
        
        database.insert(accs,false);
        
       
       SandboxOppPartners.sandpartners();
       SandboxClearReseller.clear();
       SandboxResellerAdd.resellers();
    */
        
    }
}