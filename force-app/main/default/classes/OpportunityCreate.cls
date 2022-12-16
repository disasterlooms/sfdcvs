public without sharing class OpportunityCreate {
    
    public static void pricebook(List<Opportunity> records) {
        
        Map<String, Pricebook2> pbs = new Map<String, Pricebook2>();
        for (Pricebook2 pb : [
            SELECT Id, Channel_Pricing__c, currencyIsoCode__c
            FROM Pricebook2
            WHERE isactive = TRUE AND Channel_Pricing__c != NULL
        ])
        pbs.put(pb.Channel_Pricing__c, pb);
        system.debug('pbs');
         system.debug(pbs);
        for (Opportunity o : records) {
            if (pbs.containsKey(o.Channel__c)) {
                Pricebook2 pbk = pbs.get(o.Channel__c);
                o.Pricebook2Id = pbk.Id;
                system.debug(pbk.currencyIsoCode__c);
                if(pbk.currencyIsoCode__c != null){
                    o.CurrencyIsoCode = pbk.currencyIsoCode__c;
                }
            }   
        }
    }
    
    public static void resellerbidreg(List<Opportunity> records) {
        /*
            List<Id> oppresellers = new List<Id>();
            List<Id> cons = new list<Id>();        
            
            for(Opportunity opp : records){
            oppresellers.add(opp.Partner_Account_Search__c);
            cons.add(opp.ResellerContact__c);
            
            }
            
            Map<String,Account> pbs = new Map<String,Account>();
            for(Account ac : [Select Id,ownerid,name,owner.manager.email,owner.email from Account where id in: oppresellers]){
            pbs.put(ac.Id ,ac);
            }
            
            Map<String,Contact> con = new Map<String,Contact>();
            for(Contact cac : [Select Id,name,email from Contact where id in: cons]){
            con.put(cac.Id ,cac);
            }
            
            Map<String,User> use = new Map<String,User>();
            for(User u : [Select id,name from user where profile.name like '%quotes%' OR alias like '%guest%']){
            use.put(u.Id ,u);
            }
            
            
            for(Opportunity o : records){
            system.debug('Account Map '+pbs);
            system.debug('Contact Map '+con);
            system.debug(o.ownerid);
            system.debug('Users '+use);
            if(use.containsKey(o.ownerid)){
            String conemail = 'testapex@mail.com';                     
            Account a = pbs.get(o.Partner_Account_Search__c);
            Contact c = con.get(o.ResellerContact__c);              
            User u = use.get(o.ownerid);
            if( con.containsKey(o.ResellerContact__c) && c.Email != ''){
            conemail = c.Email;
            }
            system.debug('acct name '+a.name);
            system.debug('conuser '+u.name);
            system.debug('con map '+con);
            system.debug('oppcon '+o.ResellerContact__c);
            system.debug('account '+a);
            
            
            
            String body = '';
            body += a.Name+ 'Has submtited an Request for Bid See Details Below'+'<br/><br/>' ;
            body += 'End User: '+o.End_User_Company__c  +'<br/><br/>';
            body += 'End User Street: '+o.End_User_Street__c+ '<br/><br/>';
            body += 'End User City: '+o.End_User_City__c  +'<br/><br/>';
            body += 'End User State: '+o.End_User_State_Text__c  +'<br/><br/>';
            body += 'End User Zip: '+o.End_User_Zip__c  +'<br/><br/>';
            body += 'Distributors: '+o.Distributors_Requested__c  +'<br/><br/>';
            body += 'Products: '+o.Products__c  +'<br/><br/>';
            body += 'Quantity: '+o.Product_Quantity__c  +'<br/><br/><br/><br/>';
            body += 'https://viewsonic.lightning.force.com/lightning/r/Opportunity/'+o.Id+'/view'+'<br/><br/>';
            system.debug(body);
            
            
            
            
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            if(a.Owner.Email != null ){
            sendTo.add(a.Owner.Email);
            }
            
            if(a.Owner.Manager.Email != null ){
            sendTo.add(a.Owner.Manager.Email);
            }                     
            sendTo.add(conemail);
            
            sendTo.add(c.Email);
            String[] cc = new String[] {Label.AdminEmail};
            mail.setToAddresses(sendTo);
            mail.setSubject('Reseller Portal Bid Request from '+a.Name);
            mail.setHtmlBody(body);
            mail.setCcAddresses(cc);   
            mail.setSaveAsActivity(true);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
            }
            }
            */
    }
    
    public static void updateopp(List<Opportunity> records) {
        //if this trigger is a single record created as clone, stop the class. Clone
        //opps have their own code for creation
        
        system.debug(records + ' the stop did not work');
        //Get the current user, priecbooks for us and canada, which are the 2 auto added when
        //rep does not distinguish which pricebook
        //put the main product selelected by rep in a set string to cross query when adding oppline items
        
        User u = [
            SELECT
            Id,
            Name,
            Email,
            Distributor_Rep__c,
            PartnerDistiName__c,
            PartnerDistiEmail__c,
            PartnerDistiPhone__c,
            AccountId,
            ProfileId,
            Profile.Name
            FROM User
            WHERE Id = :UserInfo.getUserId()
        ];
        
        Pricebook2 pb = [
            SELECT Id, Name
            FROM Pricebook2
            WHERE Name = 'VSA Distributor Price List'
            LIMIT 1
        ];
        Pricebook2 pbcan = [
            SELECT Id, Name
            FROM Pricebook2
            WHERE Name = 'VSA Canadian Price List'
            LIMIT 1
        ];
        
        Set<String> accounts = new Set<String>();
        for (Opportunity record : records){
            accounts.add(record.End_User_Lookup_Account__c);
            accounts.add(record.Partner_Account_Search__c);
        }
            
        
        Map<String, Account> accts = new Map<String, Account>();
        // jason orbison 10.4.2021 adding reseller country to the map and to the opportunity
        // this will allow sharing rules by country/sub region instead of giving access to all 
        //all regions opportunities
        //
        for (Account acct : [
            SELECT Id, Name, billingstate, BillingCity, BillingPostalCode,BillingCountry,
            BillingCountryCode,vsregion__c,vssubregion__c
            FROM Account
            WHERE Id IN :accounts
        ])
            accts.put(acct.Id, acct);
        
        // go through records and if this is a distributor community partner reqeuest, update the requestor information with
        //the RSM that is over that distributor account. and update the spa stage.
        system.debug('query the opps to check for community portal');
        
        for (Opportunity opp : records) {
            if(opp.Partner_Account_Search__c != null && accts.containsKey(opp.Partner_Account_Search__c)){
                Account reseller = accts.get(opp.Partner_Account_Search__c);
                //opp.ResellerCountry__c = reseller.BillingCountry;
                opp.vsregion__c = reseller.vsregion__c;
                opp.vssubregion__c = reseller.vssubregion__c;
            }
            system.debug(
                'check if disti stagename' +
                opp.StageName +
                ' profile name and id ' +
                u.Profile.Name +
                ' ' +
                u.Profile.Id
            );
            if (
                opp.StageName == 'Distributor SPA Request' &&
                opp.pricebook2Id == null
            ) {
                system.debug('stage name1: ' + opp.StageName);
                system.debug('disti rep: ' + u.Distributor_Rep__c);
                opp.PriceBook2Id = pb.Id;
                /*
                    opp.Spa_Request__c = 'Spa Request';
                    opp.Spa_Stage__c = 'Submitted';
                    opp.Spa_Request_Submitter__c = u.Distributor_Rep__c;
                    opp.Spa_Submitter_Email__c = u.PartnerDistiEmail__c;
                    opp.Requester_Email__c = u.PartnerDistiEmail__c;  
                    opp.Requester_Phone__c = u.PartnerDistiPhone__c;  
                    opp.Requester_Name__c = u.PartnerDistiName__c;              
                    
                    */
                
                system.debug('stage name2: ' + opp.StageName);
            }
        }
        
        Set<String> families = new Set<String>();
        for (Opportunity record : records)
            families.add(record.Product_Name_Main__c);
        
        Map<String, Product2> managers = new Map<String, Product2>();
        
        for (Product2 manager : [
            SELECT Id, Name
            FROM Product2
            WHERE Id IN :families
        ])
            managers.put(manager.Id, manager);
        
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for (Opportunity record : records) {
            //check if distributor account
            if (record.Product_Name_Main__c != null) {
                record.Product_Name__c = managers.get(record.Product_Name_Main__c).Name;
            }
            
            if (record.Pricebook2Id == null && record.Country__c == 'United States') {
                record.Pricebook2Id = pb.id;
            }
            
            if (record.End_User_Lookup_Account__c != null) {
                record.End_User_Company__c = accts.get(
                    record.End_User_Lookup_Account__c
                )
                    .Name;
                record.End_User_City__c = accts.get(record.End_User_Lookup_Account__c)
                    .BillingCity;
                record.End_User_State_Text__c = accts.get(
                    record.End_User_Lookup_Account__c
                )
                    .billingstate;
                record.End_User_Zip__c = accts.get(record.End_User_Lookup_Account__c)
                    .BillingPostalCode;
                record.AccountId = record.End_User_Lookup_Account__c;
            }
            
            /*
            if(record.StageName !='Distributor SPA Request'){
            record.Spa_Request_Submitter__c = u.Id;
            record.Spa_Submitter_Email__c = u.Email;
            }
            */
        }
    }
    
    public static void createchildrecords(List<Opportunity> records) {
        //if this trigger is a single record created as clone, stop the class. Clone
        //opps have their own code for creation
        
        system.debug('after insert did not stop');
        List<Opportunity> opportunities = new List<Opportunity>(records);
        List<Opportunity> oppsSpaLinked = new List<Opportunity>();
        //first remove any spa that is linked to pipeline copied list to new list to make changes to the list
        //This will copy all child records to the spa from the opportunity where the products have not been shipped yet
        for (Integer j = 0; j < opportunities.size(); j++) {
            if (opportunities.get(j).SpaCreateFOpp__c != null) {
                system.debug('removed  ' + opportunities.get(j).Name);
                oppsSpaLinked.add(opportunities.get(j));
                opportunities.remove(j);
            }
        }
        
        if (oppsSpaLinked.size() > 0) {
            //OppSpaLink.updatespas(oppsSpaLinked);
        }
        
        system.debug('the spas linked list ' + oppsSpaLinked);
        
        //update fields for distributor external communtity members and the exit from trigger
        
        Set<String> products = new Set<String>();
        Set<String> pricebooks = new Set<String>();
        Set<String> euaccounts = new Set<String>();
        Set<String> ownerids = new Set<String>();
        //get the end user and reseller account and then update the account teams
        //later in class, will add the teams
        Set<Id> oppaccounts = new Set<Id>();
        Set<Id> teamaccounts = new Set<Id>();
        Set<String> resaccounts = new Set<String>();
        
        Double price = null;
        
        for (Opportunity opp : [
            SELECT
            Id,
            Name,
            Spa_Id__c,
            StageName,
            Pricebook2Id,
            Partner_Account_Search__c,
            AccountId,
            Product_Name_Main__c,
            End_User_Lookup_Account__c,
            End_User_Lookup_Account__r.Name,
            End_User_Lookup_Account__r.billingstate,
            End_User_Lookup_Account__r.BillingCity,
            End_User_Company__c,
            End_User_City__c,
            OwnerId
            FROM Opportunity
            WHERE Id = :opportunities
        ]) {
            opp.End_User_Company__c = opp.End_User_Lookup_Account__r.Name;
            opp.End_User_City__c = opp.End_User_Lookup_Account__r.BillingCity;
            opp.End_User_State_Text__c = opp.End_User_Lookup_Account__r.billingstate;
            
            system.debug('stage name2: ' + opp.StageName);
            //while looping add the product and price book to the Set strings and then use them later to map products
            //and accessories
            products.add(opp.Product_Name_Main__c);
            pricebooks.add(opp.pricebook2Id);
            euaccounts.add(opp.End_User_Lookup_Account__c);
            ownerids.add(opp.OwnerId);
            resaccounts.add(opp.Partner_Account_Search__c);
            resaccounts.add(opp.Partner_Account_Search__c);
            resaccounts.add(opp.AccountId);
            oppaccounts.add(opp.AccountId);
            oppaccounts.add(opp.Partner_Account_Search__c);
        }
        
        //creating map for the end user account to user later in updates and inserts of opp records
        //since it is not needed at the time of this comment written, will comment out the map
        //Map<String, Account> accts = new Map<String, Account>();
        //for (Account acct : [
        //SELECT Id,Name,State__c,BillingCity,BillingPostalCode,BillingState,Industry,Type FROM Account
        //WHERE Id IN :euaccounts
        //]) accts.put(acct.Id , acct);
        
        Map<String, User> owners = new Map<String, User>();
        for (User u : [
            SELECT Id, Sales_Category__c, LastName, FirstName
            FROM User
            WHERE Id IN :ownerids
        ])
            owners.put(u.Id, u);
        
        List<Account> accounts = [
            SELECT
            Id,
            Type,
            Industry,
            BillingState,
            Name,
            BillingCountry,
            OwnerId
            FROM Account
            WHERE id IN :teamaccounts
            FOR UPDATE
        ];
        
        //calling helper class to update the account teams of end user and reseller
        //AccountTeamAdd.teams(accounts);
        
        //get the ids of the accessory products and main products to put in map
        //and link to opportunities
        String prodpb = '';
        
        Set<String> accproducts = new Set<String>();
        
        //need to go through the accessories twice,
        //once for the list relating to the opp main product and
        //another for mapping the price book entry
        //
        List<Accessories__c> accessories = [
            SELECT Id, Name, Accessory_Product__c, Main_Product__c
            FROM Accessories__c
            WHERE Main_Product__c IN :products AND AutoAdd__c = TRUE
        ];
        for (Accessories__c acc : accessories) {
            products.add(acc.Accessory_Product__c);
            accproducts.add(acc.Accessory_Product__c);
        }
        
        Map<String, PricebookEntry> lineitems = new Map<String, PriceBookEntry>();
        for (PriceBookEntry p : [
            SELECT Id, Product2Id, Pricebook2Id, UnitPrice
            FROM PriceBookEntry
            WHERE Product2Id IN :products
        ]) {
            prodpb = String.valueOf(p.Product2Id) + String.valueOf(p.pricebook2Id);
            lineitems.put(prodpb, p);
        }
        //Create List of opp contact roles for later insert
        List<OpportunityContactRole> rolesToInsert = new List<OpportunityContactRole>();
        
        //Create List of contact roles for later insert, this is for list view emails to be sent out. the contact role links contacts in salesforce and outlook api
        List<Contact_Role__c> opprolestoinsert = new List<Contact_Role__c>();
        
        //get user id to add for opp team
        User u = [
            SELECT Id, Name, Email
            FROM User
            WHERE Id = :UserInfo.getUserId()
            LIMIT 1
        ];
        
        List<Account> distis = new List<Account>();
        
        //Pull Disti Accounts if the region of first record is not U.S. This is set for one record really
        //if there are mulitple opportunities, then do not want to run this as it could cause other errors
        if (
            records[0].Country__c != 'United States' &&
            records[0].Channel__c != 'Canada AV'
        ) {
            distis = [
                SELECT Id, Name, BillingCountry
                FROM Account
                WHERE
                (BillingCountry = 'Canada'
                 OR BillingCountry = 'Mexico')
                AND Auto_Create_Disti__c = TRUE
                FOR UPDATE
            ];
            system.debug('queried distributors ' + distis);
        }
        
        if(distis.size()== 0 && test.isRunningTest()){
            distis = [
                SELECT Id, Name, BillingCountry
                FROM Account
                WHERE
                (BillingCountry = 'United States')
                AND Auto_Create_Disti__c = TRUE
                FOR UPDATE
            ]; 
        }
        
        //Create a list of Disti Account Teams
        
        List<AccountTeamMember> distiacctteam = [
            SELECT Id, UserId, AccountId, Account.BillingCountry, TeamMemberRole
            FROM AccountTeamMember
            WHERE AccountId IN :distis
        ];
        
        System.debug('disti team: ' + distiacctteam);
        
        //create list for opportunity partners to add for any amount of opportunities in trigger
        List<Opportunity_Partner__c> partsToInsert = new List<Opportunity_Partner__c>();
        
        //create list for opportunity teammembers to add for any amount of opportunities in trigger
        List<OpportunityTeamMember> oppTeamtoInsert = new List<OpportunityTeamMember>();
        
        //add main product to opportunities
        //This list holds all line items for all products and opportunities in this trigger, assuming there are 200 opportunities per triggered event
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        
        //first loop through records and find the distributor spas and then create opportunity partners
        //and opportunity teams for those deals
        
        User u1 = [
            SELECT
            Id,
            Name,
            Email,
            Distributor_Rep__c,
            PartnerDistiName__c,
            PartnerDistiEmail__c,
            PartnerDistiPhone__c,
            AccountId
            FROM User
            WHERE Id = :UserInfo.getUserId()
            LIMIT 1
        ];
        
        system.debug('theuseracctid when partner: ' + u1.AccountId);
        
        List<AccountTeamMember> partnersdisti = [
            SELECT Id, UserId, AccountId, Account.BillingCountry, TeamMemberRole
            FROM AccountTeamMember
            WHERE AccountId = :u1.AccountId
            ORDER BY TeamMemberRole DESC
        ];
        system.debug('size of list partnersdisti' + partnersdisti.size());
        
        List<OpportunityTeamMember> disttteaminsert = new List<OpportunityTeamMember>();
        
        List<Account> raccounts = new List<Account>();
        User cr = [Select id, contact.account.type from user where id =: UserInfo.getUserId()];
        String partType = cr.contact.account.type;
        
        for (Opportunity opp : opportunities) {
            if ((opp.StageName == 'Distributor SPA Request' || opp.Submission_Type__c  == 'Portal Distribution')
               && partType == 'Distributor')
             {
                Opportunity_Partner__c pdistributor = new Opportunity_Partner__c(
                    Opportunity__c = opp.id,
                    Partner_Type__c = 'Distributor',
                    Partner_Account__c = u1.AccountId
                );
                if (u1.AccountID != null) {
                    partsToInsert.add(pdistributor);
                }
                
                //add reseller to opportunity partner if it is given
                //also check for reseller contact
                
                if (opp.Partner_Account_Search__c != null) {
                    Opportunity_Partner__c partres = new Opportunity_Partner__c(
                        Opportunity__c = opp.id,
                        Partner_Type__c = 'Reseller / VAR',
                        Partner_Account__c = opp.Partner_Account_Search__c,
                        Contact_Name__c = opp.ResellerContact__r.Name,
                        Contact_Email__c = opp.ResellerContact__r.Email,
                        Reseller_Contact__c = opp.ResellerContact__c
                    );
                    partsToInsert.add(partres);
                }
                //check the query size before adding team to avoid an error
                if (partnersdisti.size() > 0) {
                    for (AccountTeamMember pt : partnersdisti) {
                        OpportunityTeamMember teampt = new OpportunityTeamMember(
                            OpportunityId = opp.Id,
                            TeamMemberRole = pt.TeamMemberRole,
                            UserId = pt.UserId,
                            OpportunityAccessLevel = 'Edit'
                        );
                        system.debug('team records before insert :' + partnersdisti);
                        
                        disttteaminsert.add(teampt);
                    }
                    
                    //system.debug('team records before insert :' +disttteaminsert);
                    
                    //since we will not be adding partner opps in bulk via insert, will put a return clause
                    //after we determine this is a partner opp. no need to continue running queries and code
                }
            }
            if (
                lineitems.containsKey(
                    String.valueOf(opp.Product_Name_Main__c) +
                    String.valueOf(opp.Pricebook2Id)
                )
            ) {
                PricebookEntry pbem = lineitems.get(
                    String.valueOf(opp.Product_Name_Main__c) +
                    String.valueOf(opp.Pricebook2Id)
                );
                if (opp.product_sales_price__c != null) {
                    price = opp.product_sales_price__c;
                } else {
                    price = pbem.UnitPrice;
                }
                OpportunityLineItem pbmain = new OpportunityLineItem(
                    PricebookEntryId = pbem.Id,
                    Quantity = opp.Product_Quantity__c,
                    UnitPrice = price,
                    OpportunityId = opp.Id
                );
                opportunityLineItems.add(pbmain);
                if (opp.DonotAddAccessories__c == false) {
                    for (Accessories__c acc : accessories) {
                        if (pbem.Product2Id == acc.Main_Product__c) {
                            PricebookEntry pbea = lineitems.get(
                                String.valueOf(acc.Accessory_Product__c) +
                                String.valueOf(opp.Pricebook2Id)
                            );
                            
                            OpportunityLineItem pbacc = new OpportunityLineItem(
                                PricebookEntryId = pbea.Id,
                                Quantity = opp.Product_Quantity__c,
                                UnitPrice = pbea.UnitPrice,
                                OpportunityId = opp.Id
                            );
                            opportunityLineItems.add(pbacc);
                        }
                    }
                }
            }
            //if(opp.Reseller_Direct__c == true && opp.Partner_Account_Search__r.Name == 'Cdw LLC'){
            //string title = 'Reseller Contact: '+ opp.Reseller_Contact_Name__c+
            //' '+ opp.Reseller_Contact_Email__c;
            
            //string body =   opp.Reseller_Contact_Name__c+' '+ opp.Reseller_Contact_Email__c;
            
            //Note note = new Note(ParentId=opp.Id,Title = title , Body = body);
            //insert note;
            //}
            if (
                opp.Partner_Account_Search__c != null &&
                opp.ResellerContact__c != null &&
                opp.StageName != 'Distributor SPA Request'
            ) {
                Opportunity_Partner__c part = new Opportunity_Partner__c(
                    Opportunity__c = opp.id,
                    Partner_Type__c = 'Reseller / VAR',
                    Partner_Account__c = opp.Partner_Account_Search__c,
                    Reseller_Contact__c = opp.ResellerContact__c,
                    Contact_Phone__c = opp.ResellerContact__r.Phone,
                    Contact_Name__c = opp.ResellerContact__r.Name,
                    Contact_Email__c = opp.ResellerContact__r.Email
                );
                partsToInsert.add(part);
            }
            if (
                opp.Partner_Account_Search__c != null &&
                opp.ResellerContact__c == null &&
                opp.StageName != 'Distributor SPA Request'
            ) {
                Opportunity_Partner__c part = new Opportunity_Partner__c(
                    Opportunity__c = opp.id,
                    Partner_Type__c = 'Reseller / VAR',
                    Partner_Account__c = opp.Partner_Account_Search__c,
                    Contact_Name__c = opp.Reseller_Contact_Name__c,
                    Contact_Email__c = opp.Reseller_Contact_Email__c
                );
                
                partsToInsert.add(part);
            }
            //if this is not a reseller direct deal, then add all the US Distributors to partners
            
            String channel = '';
            if (opp.Channel__c == null) {
                channel = 'thereisnochannelselected';
            } else {
                channel = opp.Channel__c;
            }
            
            if (
                !channel.contains('Direct') &&
                opp.StageName != 'Distributor SPA Request'
            ) {
                system.debug('add all distis ' + distis);
                for (Account a : distis) {
                    //check if distributors match the country that is on the opportunity
                    
                    if (a.BillingCountry == opp.Country__c) {
                        Opportunity_Partner__c distipart = new Opportunity_Partner__c(
                            Opportunity__c = opp.id,
                            Partner_Type__c = 'Distributor',
                            Partner_Account__c = a.Id
                        );
                        partsToInsert.add(distipart);
                        system.debug('the disti to be added' + distipart);
                    }
                    // check if reseller contacts exist
                    if (
                        opp.ResellerContact__c != null &&
                        opp.StageName != 'Distributor SPA Request'
                    ) {
                        OpportunityContactRole conrole = new OpportunityContactRole(
                            OpportunityId = opp.id,
                            Role = 'Reseller/VAR',
                            ContactId = opp.ResellerContact__c
                        );
                        rolesToInsert.add(conrole);
                        
                        Contact_Role__c contactrole = new Contact_Role__c(
                            Opportunity__c = opp.id,
                            Role__c = 'Reseller Contact',
                            Contact__c = opp.ResellerContact__c
                        );
                        opprolestoinsert.add(contactrole);
                    }
                    //check if end user contact exists
                    if (
                        opp.End_User_Contact__c != null &&
                        opp.StageName != 'Distributor SPA Request'
                    ) {
                        OpportunityContactRole conrole2 = new OpportunityContactRole(
                            OpportunityId = opp.id,
                            Role = 'End User',
                            ContactId = opp.End_User_Contact__c
                        );
                        
                        rolesToInsert.add(conrole2);
                        
                        Contact_Role__c contactrole2 = new Contact_Role__c(
                            Opportunity__c = opp.id,
                            Role__c = 'End User Contact',
                            Contact__c = opp.End_User_Contact__c
                        );
                        
                        opprolestoinsert.add(contactrole2);
                    }
                }
            }
        }
        Map<String, Opportunity_Partner__c> partnersToClean = new Map<String, Opportunity_Partner__c>();
        for (Opportunity_Partner__c op : partsToInsert) {
            partnersToClean.put(op.Partner_Account__c, op);
        }
        List<Opportunity_Partner__c> partnersToInsert = new List<Opportunity_Partner__c>();
        for (Opportunity_Partner__c opp : partnersToClean.values()) {
            partnersToInsert.add(opp);
        }
        
        Map<String, Contact_Role__c> rolesToClean = new Map<String, Contact_Role__c>();
        for (Contact_Role__c ocr : opprolestoinsert) {
            rolesToClean.put(
                String.valueOf(ocr.Contact__c) + String.valueOf(ocr.Opportunity__c),
                ocr
            );
        }
        
        List<Contact_Role__c> crolesToInsert = new List<Contact_Role__c>();
        for (Contact_Role__c ocrc : rolesToClean.values()) {
            crolesToInsert.add(ocrc);
        }
        
        Map<String, OpportunityContactRole> conRolesToClean = new Map<String, OpportunityContactRole>();
        for (OpportunityContactRole ocr : rolesToInsert) {
            conRolesToClean.put(
                string.valueOf(ocr.ContactId) + string.valueOf(ocr.OpportunityId),
                ocr
            );
        }
        
        List<OpportunityContactRole> conRolesToInsert = new List<OpportunityContactRole>();
        for (OpportunityContactRole ocrc : conRolesToClean.values()) {
        }
        
        //database.insert(disttteaminsert, false);
        system.debug('line items ' + opportunityLineItems);
        //removing contact roles from insert to help deterimine
        //cause of account  records locking
        
        database.insert(opportunityLineItems, false);
        database.insert(conRolesToInsert, false);
        database.insert(crolesToInsert, false);
        
        for (Opportunity_partner__c op : partsToInsert) {
            oppaccounts.add(op.Partner_Account__c);
        }
        //will go through opps and add the disti team to the opp unless
        //it is a consumer deal. Then will only add the disti team
        //when a spa is created
        //this may need to be changed when allocation approval process
        //is created on salesforce because the disti team may need to know about
        //the allocation
        //may just add the full team at that time and call OpportunityTeamAdd class
        
        List<AccountTeamMember> oppteam = [
            SELECT Id, UserId, TeamMemberRole
            FROM AccountTeamMember
            WHERE
            AccountId IN :oppaccounts
            AND TeamMemberRole != 'External Distribution Partner'
        ];
        String quant = '1';
        List<Product_Package__c> packages = new List<Product_Package__c>();
        String recid = '';
        
        for (Opportunity op : opportunities) {
            // allow sales to create a customized bundle and use this bundle by
            // adding bundle on the opportunity creation page
            // this will reduce by a couple steps adding customized bundles
            // and allow each rep to manager their bundles based on there ever changing
            // business needs
            //
            if (records.size() == 1 && op.My_Custom_Bundle__c != null) {
                recid = op.Id;
                quant = string.valueOf(op.Product_Quantity__c);
                Product_Package__c p = new Product_Package__c(
                    id = op.My_Custom_Bundle__c
                );
                packages.add(p);
                OppPackageProducts.addRecords(recid, packages, quant);
            }
            
            User owner = owners.get(op.OwnerId);
            for (AccountTeamMember atm : oppteam) {
                //check if this is a consumer before adding end user team
                if (owner.Sales_category__c != 'Consumer') {
                    OpportunityTeamMember euteam = new OpportunityTeamMember(
                        OpportunityId = op.Id,
                        TeamMemberRole = atm.TeamMemberRole,
                        UserId = atm.UserId,
                        OpportunityAccessLevel = 'Edit'
                    );
                    oppTeamtoInsert.add(euteam);
                } else {
                }
            }
        }
        database.insert(oppTeamtoInsert, false);
        //there is a locking error, will attempt to lock the reseller account via query.
        //seems counter productive to do and an unneccessary query but having an error and need to isolote it or figure
        //a workaround
        try {
            insert partsToInsert;
        } catch (Exception e) {
            String t =
                'Opportunity Partner on oppcreateclass Insert Error for id ' +
                partsToInsert[0].Partner_Account__c;
            AdminErrorMessage.SendError(e, t);
        }
        
        System.debug(
            'Reseller and End user teams that will be inserted: ' + oppTeamtoInsert
        );
    }
    
    public static void recordtype(List<Opportunity> records) {
        RecordType stand = [
            SELECT DeveloperName, Id, Name, SobjectType
            FROM RecordType
            WHERE DeveloperName = 'Standard_Opportunity_Record_Type'
            LIMIT 1
        ];
        
        RecordType spa = [
            SELECT DeveloperName, Id, Name, SobjectType
            FROM RecordType
            WHERE DeveloperName = 'VS_Spa'
            LIMIT 1
        ];
        
        system.debug('record type records ' + records.size());
    }
}