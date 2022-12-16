public without sharing class portalPricingAndSpiffs {    
 @auraEnabled
    public static List<Portal_Pricing__c> getAdminRecords(Boolean spiffReq,String prod,String recordId){
        
        
        
        List<Portal_Pricing__c> pp= new List<Portal_Pricing__c>();
        Contact con = new Contact();
        try{
            con = [Select id, accountid,account.billingcountry,account.billingcountrycode, Account.partner_incentive_type__c,
                           Account.spiff_type__c from Contact where id in (Select Requester__c from Spiff_Request__c  where id =: recordId) Limit 1];  
        }catch(Exception e){
            
        }
        
        system.debug('prod '+prod);
        system.debug('spiffReq '+spiffReq);
        
        String billCountry = con.Account.BillingCountry;
        String SpiffType = con.Account.spiff_type__c;
        String IncentiveType = con.Account.partner_incentive_type__c;
        
        if(SpiffType == 'Corporate' && IncentiveType == 'Regional NSP'){
            SpiffType = 'Sales Rep';
        }
        
        AggregateResult pdate  = [select count(id), Effective_Date__c from  Portal_Pricing__c  
                                    group by Effective_Date__c order by Effective_Date__c desc  limit 1 offset 1];
        
        Date prevDate = ((Date)pdate.get('Effective_Date__c'));
        system.debug('prev date '+ prevDate);
        
        PricingEffectiveDate__c effDate = [Select Effective_Date__c from PricingEffectiveDate__c where name 
                                           = 'PricingDate' limit 1];
        
        pp = [Select id, Spiff_Amount__c,product__c,PreviousMonths__c,Effective_Date__c from Portal_Pricing__c where Effective_Date__c = : effDate.Effective_Date__c 
                  and Spiff_Amount__c > 0 and Country__c =: billCountry
                  and Partner_Incentive_Type__c =: IncentiveType and  Spiff_Type__c = : SpiffType and product__c like: prod
                 order by product__c];
        
        Map<String,Portal_Pricing__c> dpp = new Map<String,Portal_Pricing__c>();
            for(Portal_Pricing__c p : [Select id, Spiff_Amount__c,product__c,PreviousMonths__c,Effective_Date__c from Portal_Pricing__c where Effective_Date__c = : prevDate
                  and Spiff_Amount__c > 0 and Country__c =: billCountry
                  and Partner_Incentive_Type__c =: IncentiveType and  Spiff_Type__c = : SpiffType and product__c like: prod
                                       order by product__c]){
                                           dpp.put(p.product__c , p);
                                       }
            for(Portal_Pricing__c p : pp){
                if(dpp.containsKey(p.Product__c)){
                    Portal_Pricing__c prevPrice = dpp.get(p.Product__c);
                    p.PreviousMonths__c = prevPrice.Spiff_Amount__c;
                }
            }            
        
        return pp;
	
    }        
        
        
    
    @auraEnabled
    public static List<Portal_Pricing__c> getProductInfo(Boolean spiffReq,String prod){
        List<Portal_Pricing__c> pp= new List<Portal_Pricing__c>();
        Contact con = new Contact();
        try{
            con = [Select id, accountid,account.billingcountry,account.billingcountrycode, Account.partner_incentive_type__c,
                           Account.spiff_type__c from Contact where id in (Select contactid from User where id =: userInfo.getUserId()) Limit 1];  
        }catch(Exception e){
            
        }
        
        system.debug('prod '+prod);
        system.debug('spiffReq '+spiffReq);
        
        String billCountry = con.Account.BillingCountry;
        String SpiffType = con.Account.spiff_type__c;
        String IncentiveType = con.Account.partner_incentive_type__c;
        
        if(SpiffType == 'Corporate' && IncentiveType == 'Regional NSP'){
            SpiffType = 'Sales Rep';
        }
        
        PricingEffectiveDate__c effDate = [Select Effective_Date__c from PricingEffectiveDate__c where name 
                                           = 'PricingDate' limit 1];
        
        
        AggregateResult pdate  = [select count(id), Effective_Date__c from  Portal_Pricing__c  
                                    group by Effective_Date__c order by Effective_Date__c desc  limit 1 offset 1];
        
        Date prevDate = ((Date)pdate.get('Effective_Date__c'));
        system.debug('prev date '+ prevDate);
           
        /*
        for (AggregateResult ar : pdate)  {
            prevDate = ar.get(Effective_Date__c);
        }
        */
        
        
        if(spiffReq){
            pp = [Select id, Spiff_Amount__c,product__c,PreviousMonths__c,Effective_Date__c from Portal_Pricing__c where Effective_Date__c = : effDate.Effective_Date__c 
                  and Spiff_Amount__c > 0 and Country__c =: billCountry
                  and Partner_Incentive_Type__c =: IncentiveType and  Spiff_Type__c = : SpiffType and product__c like: prod
                 order by product__c];
            
            //if something no longer exists, need to create a record
            Map<String,Portal_Pricing__c> dpp = new Map<String,Portal_Pricing__c>();
            for(Portal_Pricing__c p : [Select id, Spiff_Amount__c,product__c,PreviousMonths__c,Effective_Date__c from Portal_Pricing__c where Effective_Date__c = : prevDate
                  and Spiff_Amount__c > 0 and Country__c =: billCountry
                  and Partner_Incentive_Type__c =: IncentiveType and  Spiff_Type__c = : SpiffType and product__c like: prod
                                       order by product__c]){
                                           dpp.put(p.product__c , p);
                                       }
            for(Portal_Pricing__c p : pp){
                if(dpp.containsKey(p.Product__c)){
                    Portal_Pricing__c prevPrice = dpp.get(p.Product__c);
                    p.PreviousMonths__c = prevPrice.Spiff_Amount__c;
                }
            }            
        }else if(billCountry == 'United States'){
            pp = [Select id, MAP__c,product__c from Portal_Pricing__c where Effective_Date__c = : effDate.Effective_Date__c and MAP__c > 0  and product__c like: prod
                 order by product__c];
        }else{
            pp = [Select id, MSRP__c,product__c from Portal_Pricing__c where Effective_Date__c = : effDate.Effective_Date__c and MSRP__c > 0  and product__c like: prod
                 order by product__c];
        }    
        
        return pp;
    }
}