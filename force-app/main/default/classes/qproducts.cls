public class qproducts {
        Quote q {get;set;}
        public List<QuoteLineItem> highprods {get;set;}
        public List<Spa_Claims__c> spaclaims {get;set;}
        Public Boolean inactive {get;set;}
        Public Boolean high {get;set;}
        public List<QuoteLineItem> inprods {get;set;}
        public qproducts(ApexPages.StandardController stdController){
            q = (Quote)stdController.getRecord();
            system.debug('quote' +q);
            
        }
        public PageReference getprods()
        { 
            Quote qt = [Select Id,OpportunityId,AccountId from Quote where id =: q.id]; 
            
            highprods = [Select Id,Product2.name,Quantity,Approved_Price__c,ListPrice,Pricebookentry.UnitPrice, Active_Product__c,Margin__c ,Landed_Cost__c  
                         from QuoteLineItem where QuoteId =: q.Id and ApprovedPriceHiigherLIst__c  = true];
            if(highprods.size() > 0){
                high=true;
                    }else{
                        high = false;
                    }
            
            inprods = [Select Id,Product2.name,Quantity,Approved_Price__c,ListPrice,Pricebookentry.UnitPrice, Active_Product__c  
                       from QuoteLineItem where QuoteId =: q.Id and Active_Product__c  = false];
            
            if(inprods.size() > 0){
                inactive=true;
                    }else{
                        inactive = false;
                    }
            
            spaclaims = [Select Id, Product__c , Quantity__c, Order_Date__c ,Creation_Date__c ,Total_Spa_Amount__c,Transaction_Line_Amount__c ,Unit_Selling_Price__c ,Spa_Price__c ,SKU__c,
                          SKU__r.Name,SKU__r.family
                         from Spa_Claims__c where opportunity__c = : qt.OpportunityId order by Order_Date__c  desc];
            
            return null;
        }
     public PageReference uphighprods()
        {
            update highprods;
            return null;
        }
     public PageReference upInactive()
        {
            update inprods;
            return null;
        }
    
        
    }