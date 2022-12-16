public class MasterAssetClass{
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Asset> oldAssets;
    Map<Id, Asset> newAssets;
    
    
    public MasterAssetClass(
        Map<Id, Asset> oldTriggerAssets, 
        Map<Id, Asset> newTriggerAssets) {
            oldAssets = oldTriggerAssets;
            newAssets = newTriggerAssets;
        }
    public static void assetNullData(List<Asset> records) {
        for(Asset a : records){
            if(a.order__c == null || a.order__c == ''){a.order__c = 'noOrderNumGiven';
            }}  
        
        
    }
    
    public void spiffRequestClaimed() {
        List<String> spiffs = new List<String>();
        
        for(Asset a :  newAssets.values()){
            Asset old = oldAssets.get(a.Id);
            if(a.Spiff_Request__c != old.Spiff_Request__c && a.Spiff_Request__c != null){
                spiffs.add(a.Spiff_Request__c);
            }
        }
        
        Map<String,Spiff_request__c> spiffData = new Map<String,Spiff_request__c>();
        for(Spiff_request__c sp : [Select id,Requester_Company__c ,End_User__c ,
                                   End_User_Email__c , Distributor__c ,Requester__c , End_User_Contact__c
                                   from Spiff_request__c where id in: spiffs]){
                                       spiffData.put(sp.Id,sp);
                                   }
        
        Account vsa = [Select id,name from account where name = 'ViewSonic Corporation' and Type = 'End User' limit 1];
        system.debug('vsa '+vsa);
        Account testA = new Account();
        system.debug('spiff info '+spiffData );
        system.debug('asset info '+ newAssets.values());
        for(Asset a :  newAssets.values()){            
            if(spiffData.containsKey(a.Spiff_Request__c))  {
                Spiff_Request__c s = spiffData.get(a.Spiff_Request__c);
                if(a.Distributor_Account__c == null){
                    a.Distributor_Account__c = s.Distributor__c;
                }
                if(a.Reseller_Account__c == null){
                    a.Reseller_Account__c = s.Requester_Company__c;                     
                }
                if(a.AccountId == vsa.Id || a.AccountId == '0011200001Dq2NAAAZ'){
                    system.debug('update accId '+ s.End_User__c);
                    a.AccountId = s.End_User__c;
                }
                if(a.contactId == null){
                    a.contactId = s.End_User_Contact__c;
                }
            } 
        }
        
    }
    public static void newAsset(List<Asset> records) {
        // Clean the formatting of the spas 
        // Create a list of spas in order to get account ids
        // Also update the asset with cleaned up spa
        // 
        Set<String> spas = new Set<String>();
        Set<String> aliases = new Set<String>();
        Set<String> endUserCleansed = new Set<String>();
        Set<String> prods = new Set<String>();
        Set<String> SerialTest = new Set<String>();
        
        
        
        
        
        
        Account viewsonic = [Select id from account where name = 'ViewSonic Corporation' limit 1];
        
        for(Asset s : records){
            prods.add(s.Product__c);            
            if(s.isShipmentData__c == 'TRUE'){
                SerialTest.add(s.SerialNumber);
            }
            
            if(s.BundleItem__C != null && s.BundleItem__C != ''){
                String prod = s.product__c.left(s.product__c.indexOf('-'));
                String bund = s.BundleItem__c.left(s.BundleItem__c.indexOf('-'));
                if(prod != bund){
                    s.Price = 0;
                }
            }
            
            
            s.AccountId = viewsonic.Id;
            if(s.SpaId__c != null){
                String spa = s.SpaId__c.toUpperCase() ;
                spa = spa.remove(' ');
                spa = spa.remove('/');
                spa = spa.remove('BR');
                spa = spa.remove('ACC');
                spa = spa.remove('-');
                spa = spa.remove('/');
                s.SpaId__c  = spa;
                spas.add(spa);
            }else  if(s.SpaId2__c != null){
                String spa = s.SpaId2__c.toUpperCase();
                spa = spa.remove(' ');
                spa = spa.remove('/');
                spa = spa.remove('BR');
                spa = spa.remove('ACC');
                spa = spa.remove('-');
                spa = spa.remove('/');
                s.SpaId__c  = spa;
                spas.add(spa);
            }
            if(s.End_User_Cleansed__c != '' && s.End_User_Cleansed__c != null && s.End_User_Cleansed__c != ' '){
                s.End_User__c = s.End_User_Cleansed__c; 
            }
            
            aliases.add(s.TP__c);
            aliases.add(s.Reseller__c);
            aliases.add(s.End_User__c);
            endUserCleansed.add(s.End_User__c );
            
            if(s.product__c != null &&  (s.product__c.toUpperCase().startsWith('IFP') ||
                                         s.product__c.toUpperCase().startsWith('VA2252SM') ||
                                         s.product__c.toUpperCase().startsWith('VA2452SM') ||
                                         s.product__c.toUpperCase().startsWith('VA2452SM') ||
                                         s.product__c.toUpperCase().startsWith('VG2239SMH') ||
                                         s.product__c.toUpperCase().startsWith('VG2439SMH'))
               && (s.product__c.toUpperCase().endsWith ('-2') || s.product__c.toUpperCase().endsWith ('-3')
                   || s.product__c.toUpperCase().endsWith ('-3'))){
                       s.Product__c = s.product__c.removeEndIgnoreCase('-2');
                       s.Product__c = s.product__c.removeEndIgnoreCase('-3');
                       s.Product__c = s.product__c.removeEndIgnoreCase('-4');
                   }  
            
            prods.add(s.Product__c);
            
        }
        
        // get map of opportunities with the account id as the key to update assets end user account info
        // 
        system.debug('oppquery');
        Map<String, Opportunity> opps = new Map<String,Opportunity>();
        for(Opportunity o : [Select id, AccountId, Spa_ID__c, SPA_Resellers__c ,
                             (Select partner_account__c,Partner_account__r.Name from Opportunity_partners__r 
                              where Partner_Type__c = 'Reseller / VAR'
                              and opportunity__r.SPA_Resellers__c =1)
                             from opportunity 
                             where Spa_ID__c in : spas
                             and Spa_ID__c != null]){
                                 opps.put(o.SPA_ID__c , o);  
                             }
        
        
        
        
        // mapping the product
        Map<String, Product2> prodMap = new Map<String,Product2>();
        
        for(Product2 p : [Select id,name from Product2 
                          where name in : prods]){
                              prodMap.put(p.Name , p);  
                          } 
        
        
        
        //get map of reseller and distributor account aliases to map the Account Names
        Map<String,POSAccountAliases__c> distis = new Map<String,POSAccountAliases__c>();
        Map<String,POSAccountAliases__c> resellers = new Map<String,POSAccountAliases__c>();
        Map<String,POSAccountAliases__c> endusers = new Map<String,POSAccountAliases__c>();
        system.debug('pos query');
        for(POSAccountAliases__c p:  [Select id, DistributorAlias__c ,Reseller_Alias__c,End_User_Alias__c,
                                      SFDC_Account__c  from POSAccountAliases__c  where (DistributorAlias__c in : aliases
                                                                                         or Reseller_Alias__c in : aliases
                                                                                         or End_User_Alias__c in : aliases)
                                      and name != null
                                      limit 5000]){
                                          distis.put(p.DistributorAlias__c , p);
                                          resellers.put(p.Reseller_Alias__c , p);
                                          endusers.put(p.End_User_Alias__c, p);
                                      }
        
        //get map of end user aliases from end user cleansed
        Map<String, Account> acc = new Map<String,Account>();
        
        system.debug('acct eu clensed query');
        for(Account o : [Select id,POS_Alias__c,assetChange__c   from Account where POS_Alias__c  in : endUserCleansed and
                         POS_Alias__c != null limit 2000]){
                             acc.put(o.POS_Alias__c , o);
                             
                         } 
        
        for(Asset a : records){
            
            if(distis.containsKey(a.TP__c )){
                POSAccountAliases__c o = distis.get(a.TP__c );
                a.Distributor_Account__c  = o.SFDC_Account__c;
            }
            if(resellers.containsKey(a.Reseller__c) && a.Reseller__c != null){
                POSAccountAliases__c res = resellers.get(a.Reseller__c );
                a.Reseller_Account__c  = res.SFDC_Account__c;
                
            }
            if(opps.containsKey(a.SpaId__c )){
                Opportunity o = opps.get(a.SpaId__c);
                a.AccountId = o.AccountId;
                a.Opportunity__c = o.Id;
                if(a.Reseller_Account__c == null && o.Opportunity_partners__r.size()>0){
                    a.Reseller_Account__c = o.Opportunity_partners__r[0].partner_account__c;
                    a.Reseller__c = o.Opportunity_partners__r[0].Partner_account__r.Name;
                }
            }
            //only use this map if spa was not found 
            if( a.Id != viewsonic.Id){
                // checking if account POSAlias is present
                if(acc.containsKey(a.end_user__c)){
                    Account eu = acc.get(a.end_user__c );
                    a.AccountId  = eu.Id;
                    // checking if  POSAlias object has record 
                }else if(endusers.containsKey(a.end_user__c)){
                    POSAccountAliases__c eua = endusers.get(a.end_user__c );
                    a.AccountId  = eua.SFDC_Account__c;
                }
            }
            
            if(prodMap.containsKey(a.product__c )){
                Product2 pr = prodMap.get(a.product__c );
                a.Product2Id   = pr.Id;
                prods.add(pr.Id);
            }
            
        }
        Map<Id,Account> accts = new Map<Id,Account>();
        
        for(Asset a : records){
            system.debug('adding account to map asset');
            Account euact = new Account();
            euact.Id = a.AccountId;
            euact.assetChange__c = true;      
            accts.put(euact.Id, euact);
            
            if(a.Reseller_Account__c == null){              
                Account resact = new Account();
                resact.Id = a.AccountId;
                resact.assetChange__c = true;
                accts.put(resact.Id, resact);
            }
        }
        system.debug('aasset acct map');
        system.debug(accts);
        update accts.values();
        
        Map<String,Asset> existingSerials = new Map<String,Asset>();
        for(Asset a : [Select id, serialnumber from asset where serialnumber in : SerialTest]){
            existingSerials.put(a.SerialNumber, a);
        }
        Set<Id> assetsToDelete = new Set<Id>();
        for(Asset s : records){            
            if(s.isShipmentData__c == 'TRUE'){
                if(existingSerials.containsKey(s.SerialNumber )){
                    if(existingSerials.get(s.SerialNumber).Id != s.Id){
                        s.addError('This serial is already in system');
                        
                        //assetsToDelete.add(s.Id);
                        
                    }
                    
                }
            }
            
        }
        
        
        //mapping for quotelines
        Map<String,QuoteLineItem> lines = new Map<String,QuoteLineItem>();
        for(QuoteLineItem q : [Select id, quote.name, Product2Id,quote.Opportunity.SPA_ID__c from quotelineitem where Product2Id in : prods
                               and quote.Opportunity.SPA_ID__c in: spas order by quote.expirationdate desc  nulls last ]){
                                   String quoteId = q.quote.Opportunity.SPA_ID__c+q.Product2Id;
                                   lines.put(quoteId,q); 
                                   system.debug('spa name and product '+ quoteId);
                               }
        
        for(Asset a : records){
            String lineKey = a.SpaId__c+a.Product2Id;
            system.debug('spa line key '+lineKey+ ' sn '+a.SerialNumber);
            if(lines.containsKey(lineKey)){
                QuoteLineItem ql = lines.get(lineKey);
                a.Spa_Product__c = ql.Id;
            }
        }
        
        
    }
    @future
    public static void assetToDelete(Set<Id> records) {
        List<Asset> ass = [select id from Asset where id in : records];
        delete ass;
        
    }
}