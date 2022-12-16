public class OppProductUpdates{
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, OpportunityLineItem> oldOpps;
    Map<Id, OpportunityLineItem> newOpps;
    
    
    public OppProductUpdates(
        Map<Id, OpportunityLineItem> oldTriggerOpps, 
        Map<Id, OpportunityLineItem> newTriggerOpps) {
            oldOpps = oldTriggerOpps;
            newOpps = newTriggerOpps;
        }
    
    // The one method your master trigger will call
    public static void newProduct(List<OpportunityLineItem> records) {
        
        //is state spa update, do not do any actions
        //for(OpportunityLineItem l : records){
            //if(l.IsSyncFromQuote__c){
                //return;
            //}
        //}
        
        //Set<String> opps = new Set<String>();
        //for(Opportunitylineitem p : records){
            //opps.add(p.OpportunityId);
            
            
        //}
        
        //if there is a spa already created and then a person adds a product to opp 
        //products, need to add to quotes. this is only necessary until all product will be added by bid desk
        
        //List<QuoteLineItem> lines = new List<QuoteLineItem>();
        
        //Map<String,Opportunity> oppstage = new Map<String, Opportunity>();
        //for(Opportunity o : [Select id,Spa_Stage__c,(Select id from Quotes Order by CreatedDate desc) from Opportunity where id in : opps])
           // oppstage.put(o.id , o);
        
        //for(Opportunitylineitem p : records){
            //Opportunity op = oppstage.get(p.OpportunityId);
            //system.debug('stage and size '+op.Spa_Stage__c +' '+op.Quotes.size());
            //if(op.Spa_Stage__c != null && op.Quotes.size() >0){
                //QuoteLineItem q = new quotelineitem(QuoteId= op.Quotes[0].Id,Pricebookentryid = p.Pricebookentryid,Quantity = p.Quantity,UnitPrice = p.UnitPrice,Competitor_Name_del__c =  p.Competitor_Name_del__c,Competitor_Price_del__c = p.Competitor_Price_del__c ,
                                                    //Competitor_SKU__c = p.Competitor_SKU__c ,Notes__c = p.Competitor_SKU__c,
                                                    //MarginMultiEdit__c   = p.Margin__c );
                //lines.add(q);
            //}
            
        //}
        //database.insert(lines);
        
    }
    public static void newSchedule(List<OpportunityLineItem> records) {
        System.debug('Records passed' +records);
        //is state spa update, do not do any actions
        for(OpportunityLineItem l : records){
            if(l.IsSyncFromQuote__c){
                return;
            }
        }
        List<OpportunityLineItem> lines = new List<OpportunityLineItem>();
        if(trigger.isInsert){
            lines = [Select Id,Quantity,Opportunity.CloseDate from OpportunityLineItem where Id in: records
                                           and Product2.CanUseQuantitySchedule = true];
             System.debug('After Insert Trigger' +lines);
        }else if(trigger.isUpdate){
            try{
                 lines = [Select Id,Quantity,Opportunity.CloseDate from OpportunityLineItem where Id in: records
                     AND HasQuantitySchedule = false and Product2.CanUseQuantitySchedule = true];
                 System.debug('Before Insert Trigger' +lines);
            } catch(Exception e){
                
            }
           
        }
     
        
        system.debug('schedulable lines '+lines.size());
        
         Map<Id,OpportunityLineItem> lineup = new Map<Id,OpportunityLineItem>(lines);
        
        List<Date> dates = months.getMonths();
        List<OpportunityLineItemSchedule> schedules = new List<OpportunityLineItemSchedule>();
        system.debug('dates size '+dates.size());

        for(OpportunityLineItem l : lines){
            for(Date d : dates){
                OpportunityLineItemSchedule sch = new OpportunityLineItemSchedule(opportunitylineitemid= l.Id,
                                                                                  Quantity = 0,
                                                                                  ScheduleDate = d,
                                                                                  Type = 'Quantity');
                schedules.add(sch);
                system.debug('schedules'+schedules);
                
            }
        }
        insert schedules;
        
       
       List<OpportunityLineItem> linetoup = [Select Id,Quantity,
                                            (Select Id,Quantity,ScheduleDate from OpportunityLineItemSchedules order by ScheduleDate asc) 
                                           from OpportunityLineItem where id in: lines];
        
        
        
        system.debug('linetoup'+linetoup);
        system.debug(lineup);
        for(OpportunityLineItem op : linetoup){
            Opportunitylineitem ol = lineup.get(op.Id);
            system.debug('maps close date');
            system.debug(ol.Opportunity.CloseDate.month());
            for(OpportunityLineItemSchedule sc : op.OpportunityLineItemSchedules){
                if(sc.ScheduleDate.month() == ol.Opportunity.CloseDate.month()){
                    sc.Quantity = ol.Quantity;
                }
            }
            update op.OpportunityLineItemSchedules;
        }
       
        
        
    }
    
}