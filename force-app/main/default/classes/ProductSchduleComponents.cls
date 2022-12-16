public class ProductSchduleComponents {
    @AuraEnabled
    public static List<OpportunityLineItemSchedule> getSchedule(String lineid){
        Date cm = System.today().toStartOfMonth().addDays(-1); 
        List<OpportunityLineItemSchedule> sch = [select Id,ScheduleDate,Quantity,type,opportunitylineitemId,
                                                 opportunitylineitem.product2.name,opportunitylineitem.opportunity.name
                                                 from OpportunityLineItemSchedule
                                                 where opportunitylineitemid =: lineid and 
                                                 ScheduleDate > :cm order by ScheduleDate asc limit 12];
        system.debug(sch);
        system.debug(lineid);
        system.debug('lineid');
        return sch;
    }
    @AuraEnabled
    public static List<Date> getmonths(){  
        
        
        List<Date> dates = months.getMonths();
        
        return dates;
    }
    @AuraEnabled
    public static void updateSched(List<OpportunityLineItemSchedule> schd){
        system.debug(schd);
        update schd;
        OpportunityLineItem p = [Select id, SchdUpdated__c ,Likely_Purchase__c 
                      from OpportunityLineItem where id =: schd[0].opportunitylineitemId limit 1];
        p.Likely_Purchase__c = true;
        p.SchdUpdated__c = date.today();
        try{update p;}catch(Exception e){String t = 'Error Product Likely';AdminErrorMessage.SendError(e, t);}
        
    }
    
}