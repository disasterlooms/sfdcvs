public class OppProducts {
    @AuraEnabled
    public static List<OpportunityLineItem> getOppLInes(String oppid){
        system.debug('oppid is ' +oppid);
        
        List<OpportunityLineItem> items = [SELECT Id,product2.name,Quantity,Ship_Out_Date__c,
                                           OpportunityId,unitprice,Status__c,TotalPrice,Likely_Purchase__c
                                           , Notes__c FROM OpportunityLineItem
                                           WHERE OpportunityId = :oppid];
        system.debug('list products '+items );
        
         system.debug('list products size '+items.size() );
        return [SELECT Id,product2.name,Quantity,Ship_Out_Date__c,OpportunityId,unitprice,
                ProductCode,Status__c,Opportunity.CloseDate,TotalPrice, Competitor_Name_del__c ,Competitor_SKU__c ,
                Competitor_Price_del__c ,Notes__c ,Likely_Purchase__c
                FROM OpportunityLineItem
                WHERE OpportunityId = :oppid];  
        
        
    }
    @AuraEnabled
    public static List<OpportunityLineItem> updateOppLines(List<OpportunityLineItem> lineitems, String oppid){
        
        Map<String, OpportunityLineItemSchedule> sch = new Map<String, OpportunityLineItemSchedule>();
        
        Map<String, OpportunityLineItemSchedule> schdate = new Map<String, OpportunityLineItemSchedule>();
        
    System.debug('lineitems size'+lineitems.size());
        for(OpportunityLineItemSchedule ls : [Select Id,OpportunityLineItemId,ScheduleDate,Quantity from OpportunityLineItemSchedule where OpportunityLineItemId in : lineitems]){
           System.debug('ls dataaaa @@'+ls);
            sch.put(ls.OpportunityLineItemId , ls);
            System.debug('sch '+sch);
            System.debug('lineitems '+lineitems);
            System.debug('ls.OpportunityLineItemId+String.ValueOf(ls.ScheduleDate.Month())' +ls.OpportunityLineItemId+String.ValueOf(ls.ScheduleDate.Month()));
            System.debug('String.ValueOf(ls.ScheduleDate.Month())'+String.ValueOf(ls.ScheduleDate.Month()));
            schdate.put(ls.OpportunityLineItemId+String.ValueOf(ls.ScheduleDate.Month()) , ls);
            System.debug('Schdate '+schdate);
        }
        
        
        List<OpportunityLineItemSchedule> schToUpdate = new List<OpportunityLineItemSchedule>();
        
        List<OpportunityLineItem> linesToUpdate = new List<OpportunityLineItem>();
        
        for(OpportunityLineItem l : lineitems){
            System.debug('l ie. 1st Item' +l);
            
            if(sch.containsKey(l.Id)){
                if(l.Ship_Out_Date__c != null){
                   System.debug('Inside Loop '+l.Ship_Out_Date__c);
                    if(schdate.containsKey(l.Id+String.valueOf(l.Ship_Out_Date__c.Month()))){
                         System.debug('Inside Loop2 ');
                        OpportunityLineItemSchedule ls = schdate.get(l.Id+String.valueOf(l.Ship_Out_Date__c.Month()));
                     
                        OpportunityLineItemSchedule lsupdate = new OpportunityLineItemSchedule(Id = ls.Id, Quantity = l.Quantity);
                         schToUpdate.add(lsupdate);
                    
                        OpportunityLineItem lprice = new OpportunityLineItem();
                        lprice.Id = l.id;
                        lprice.TotalPrice = l.Quantity*l.UnitPrice;
                        lprice.Notes__c = l.Notes__c;
                        lprice.Competitor_Name_del__c = l.Competitor_Name_del__c;
                        lprice.Ship_Out_Date__c = l.Ship_Out_Date__c;
                        lprice.Likely_Purchase__c = l.Likely_Purchase__c;
                        linesToUpdate.add(lprice);
                        
                    }
                }else{
                    System.debug('Entered in else');
                    if(schdate.containsKey(l.Id+String.valueOf(l.Opportunity.CloseDate.Month()))){
                        OpportunityLineItemSchedule ls = schdate.get(l.Id+String.valueOf(l.Opportunity.CloseDate.Month()));
                        System.debug('Earlier Quantity '+sch.get(ls.OpportunityLineItemId ).Quantity);
                        System.debug('l.Quantity'+l.Quantity);
                           //if(sch.get(ls.OpportunityLineItemId ).Quantity != l.Quantity){
                               // System.debug('Quantity Check in else');
                         // OpportunityLineItemSchedule lsupdate = new OpportunityLineItemSchedule(Id = ls.Id, Quantity = l.Quantity);
                        //schToUpdate.add(lsupdate);  
                       //}
                        OpportunityLineItemSchedule lsupdate = new OpportunityLineItemSchedule(Id = ls.Id, Quantity = l.Quantity);
                         schToUpdate.add(lsupdate);
                        System.debug('schToUpdate' +schToUpdate);
                        OpportunityLineItem lprice = new OpportunityLineItem();
                        lprice.Id = l.id;
                       //lprice.Quantity=l.Quantity;
                        System.debug('Lprice qUANTITY'+ l.Quantity);
                        System.debug('unit price qUANTITY'+ l.UnitPrice);
                        lprice.Notes__c = l.Notes__c;
                        lprice.Competitor_Name_del__c = l.Competitor_Name_del__c;
                       // lprice.Id = l.id;
                       // lprice.TotalPrice = lprice.Quantity*l.UnitPrice;
                        lprice.TotalPrice = l.Quantity*l.UnitPrice;
                      System.debug('TotalPrice' +lprice.TotalPrice);
                        lprice.Likely_Purchase__c = l.Likely_Purchase__c;
                         System.debug('Lprice qUANTITY' +lprice.Quantity);
                        System.debug('Lprice' +lprice);
                        linesToUpdate.add(lprice);
                    }
                    System.debug('End');
                }
                
                
            }else{
                linesToUpdate.add(l);
            }
        }
           List<OpportunityLineItem> lS=[select ID,Quantity,TotalPrice FROM OpportunityLineItem where ID in :linesToUpdate];
        system.debug('L ITEMSS BEFORE' +lS);       
        system.debug('schToUpdate Before Update' +schToUpdate);
        update schToUpdate;
             system.debug('schToUpdate After Update' +schToUpdate);
        	 system.debug('linesToUpdate Before Update' +linesToUpdate);
        List<OpportunityLineItem> l=[select ID,Quantity,TotalPrice FROM OpportunityLineItem where ID in :linesToUpdate];
        system.debug('L ITEMSS' +l);
        
        update linesToUpdate;
             system.debug('linesToUpdate After Update' +linesToUpdate);
        system.debug(lineitems);
        return [SELECT Id,product2.name,Quantity,Ship_Out_Date__c,OpportunityId,unitprice,TotalPrice,
                ProductCode,Status__c
                FROM OpportunityLineItem
                WHERE OpportunityId = :oppid];
        
        
    }
    @AuraEnabled
    public static List<OpportunityLineItem> deleteOppLines(List<OpportunityLineItem> dlineitems, String oppid){
        system.debug('prods ' +dlineitems);
        
        system.debug(dlineitems);
        
        Opportunity opp = [Select id,Product_Name_Main__c  from opportunity where id =:oppid ];
        opp.Product_Name_Main__c = null;
        
        try{
            update opp;
        }catch(Exception e){
            
        }
           
        delete  dlineitems;
        return [SELECT Id,product2.name,Quantity,Ship_Out_Date__c,OpportunityId,unitprice,
                ProductCode,Status__c
                FROM OpportunityLineItem
                WHERE OpportunityId = :oppid];
        
        
    }
    @AuraEnabled
    public static List<String> getStatus()  
    {
        return GetProductStatus.getStatus();
    }
}