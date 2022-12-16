public class OppCloneProducts {
    public static Id ChangePBE(List<Opportunity> opps) {
        //create a set to be passed to at future class that update the cloned opp 
        //so that it can be cloned again if need be
        Set<Id> oppsupdating = new Set<Id>();
        system.debug('Clone class');
        String oldoppid = '';
        Opportunity opp = null;
        String channel = '';
        String country = '';
        for(Opportunity o : opps){
            if(o.cloning__c == true){
                oldoppid = o.Spa_to_Transfer_to__c;
                oppsupdating.add(o.Id);
                channel = o.Channel__c;
                country = o.Country__c;
                opp = o;
            }
        }
        
        system.debug('old opp id '+ oldoppid);
        system.debug(opp+' cloned opp');
       
        Set<String> prodids = new Set<String>();
        
        Map<String, OpportunityLineItem> products = new Map<String,OpportunityLineItem>();
        
        for(OpportunityLineItem op : [Select Id, product2Id,quantity,opportunityid, opportunity.pricebook2id, opportunity.Product_Quantity__c from OpportunityLineItem
                                      where opportunityid = : oldoppid ])
        {
            products.put(op.Product2Id,op);
            prodids.add(op.Product2Id);  
        }
        
        
        List<Pricebookentry> pbes = [Select Id,UnitPrice,Product2Id from Pricebookentry where 
                                     product2Id in: prodids and pricebook2id =: opp.Pricebook2Id and isactive = true];
        
        List<OpportunityLineItem> linestoinsert = new List<OpportunityLineItem>();
        
        Double quant = 1;
        
        
        for(Pricebookentry e : pbes){
            OpportunityLineItem ol = products.get(e.Product2Id);
            if(opp.Product_Quantity__c > 0){
            	quant = opp.Product_Quantity__c;                 
            }else if(ol.Quantity > 0){               
                quant = ol.Quantity;
            }else{
                 quant = 1;
            }
            
            OpportunityLineItem nl = new OpportunityLineItem(OpportunityId = opp.Id,
                                                             Quantity= quant,
                                                             UnitPrice= e.UnitPrice,
                                                             pricebookentryid = e.Id);
            linestoinsert.add(nl);
        }
        insert linestoinsert;
        
        List<Account> distis = [SELECT Id,Name,BillingCountry FROM Account where BillingCountry =: country AND Auto_Create_Disti__c = true] ;
        system.debug('queried distributors ' +distis);
        
        
        
        if(channel == '' ||channel== null){
            channel = 'Disti';
        }
        List<AccountTeamMember> distiacctteam = [SELECT Id,UserId,AccountId,Account.BillingCountry,TeamMemberRole FROM AccountTeamMember where AccountId In:distis] ;
        
        List<Opportunity_Partner__c> partstoinsert = new List<Opportunity_Partner__c>();
        /*
         for (Account a : distis){
             if(!channel.contains('Direct')){
                 Opportunity_Partner__c distipart = new Opportunity_Partner__c(
                            Opportunity__c = opp.id, 
                            Partner_Type__c = 'Distributor',
                            Partner_Account__c = a.Id );
                        partstoinsert.add(distipart);
             }   
         }
          */
        
        
        
        for(Opportunity o : opps){
            Opportunity_Partner__c op = new Opportunity_Partner__c(Partner_Account__c = o.Partner_Account_Search__c,
                                                                   Opportunity__c = o.Id,
                                                                   Reseller_Contact__c = o.ResellerContact__c ,
                                                                   Contact_Email__c  = o.Reseller_Contact_Email__c,
                                                                   Contact_Name__c = o.Reseller_Contact_Name__c,
                                                                   Partner_Type__c = 'Reseller / VAR');
            partstoinsert.add(op);
        }
        
        insert partstoinsert;
        
        Id quoteid = null;
        if(opp.Clone_Quote_Products__c == true){
            Quote q = new Quote(OpportunityId=opp.Id,
                                name= opp.Spa_Id__c,
                                status= 'Needs Review');
            insert q;
            quoteid = q.Id;
        }
        //OpportunityTeamAdd.teams(opps);
        OppCloneProducts.updateCloneOrigin(oppsupdating);
        return quoteid;
    }
    @future
    public static void updateCloneOrigin(Set<Id> opps){
        List<Opportunity> oppsToUpdate = [Select id,Spa_to_Transfer_to__c,Cloning__c,Clone_Quote_Products__c
                                          from opportunity where id in: opps];
        
        for(Opportunity o : oppsToUpdate){
            o.Spa_to_Transfer_to__c = null;
            o.Cloning__c = false;
            o.Clone_Quote_Products__c = false;
        }
        
        database.update(oppsToUPdate, false);
        
    }
    
}