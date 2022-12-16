public class SpiffToPrices {
    @AuraEnabled
    public static void updateSpiffs(){
        
        Set<String> pb   = new Set<String>();
        Set<String> prod = new Set<String>();
        
        Map<String, Spiff__c> spiff = New Map<String, Spiff__c>();
        for(Spiff__c s : [Select id, SKU__c ,SPG__c, AV__c , CDW__c ,NSP__c ,Distrubution__c ,Max_Reseller__c, ExternalId__c,PriceBook__c
                          from Spiff__c]){
                              spiff.put(s.SKU__c+s.PriceBook__c,s);
                              pb.add(s.PriceBook__c);
                              prod.add(s.SKU__c);
                          }
        
        List<PricebookEntry> price = [Select id, Reseller_Spiff__c , Disty_Spiff__c, pricebook2.name,product2.name
                                      from PricebookEntry where product2.name in : prod ];
        List<PricebookEntry> pricetoUpdate =  new List<PricebookEntry>();
        
        Integer disti = 0;
        Integer cdw = 0;
        Integer av = 0;
        Integer dmr = 0;
        system.debug(spiff);
        for(PricebookEntry p : price){
            //system.debug(p.product2.name+p.pricebook2.name);
            
            if(spiff.containsKey(p.product2.name+p.pricebook2.name)){
                Spiff__c s = spiff.get(p.product2.name+p.pricebook2.name);
                if(p.pricebook2.name == 'VSA Distributor Price List' || p.pricebook2.name == 'VSA Canadian Price List'){
                    p.Disty_Spiff__c = s.Distrubution__c;
                    p.Reseller_Spiff__c = s.Max_Reseller__c;
                    disti = disti+1;
                }else if(p.pricebook2.name == 'VSA CDW Price List'){
                    p.Reseller_Spiff__c = s.CDW__c;
                    cdw = cdw+1;
                }else if(p.pricebook2.name == 'VSA AV Solution Partner Price List'){
                    p.Reseller_Spiff__c = s.AV__c;
                    av = av+1;
                }else if(p.pricebook2.name == 'VSA DMR Price List'){
                    p.Reseller_Spiff__c = s.NSP__c ;
                    dmr = dmr+1;
                }
                pricetoUpdate.add(p);
                
            }
        }
        
        update pricetoUpdate;
        
        system.debug('updates '+pricetoUpdate.size());
        system.debug('disti '+disti);
        system.debug('cdw '+cdw);
        system.debug('av '+av);
        system.debug('dmr '+dmr);
        
    }
}