global class OppScheduleNewMonth implements 
    Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        //need to create a schedule for 12 months out. Going to get the next year
        //will go minus one month plus one year for all months but january
        //which will go to 12 for month and same year
        //this batch will be scheduled to run 1st of each month
        
        Integer curmonth = date.today().month();
        Integer curyear = date.today().year() +1;
        
        if(curmonth == 1){
            curmonth = 12;
            curyear = curyear-1;
        }else{
            curmonth = curmonth -1;
        }
           
        return Database.getQueryLocator(
            'select id,product2.name,Opportunity.AccountId,OpportunityId from opportunitylineitem where HasSchedule = true and id not in '+
			'(Select opportunitylineitemid from opportunitylineitemschedule where CALENDAR_MONTH(ScheduleDate) = : curmonth '+
            ' and CALENDAR_Year(ScheduleDate) = : curyear) order by Opportunity.AccountId , OpportunityId '
        );
    }
    
    global void execute(Database.BatchableContext bc, List<OpportunityLineItem> lines){
        // process each batch of records
        
        Date year = date.today().addmonths(11);
        
        List<OpportunityLineItemSchedule> linesToInsert = new List<OpportunityLineItemSchedule>();
        
        for(OpportunityLineItem l : lines){
            OpportunityLineItemSchedule s = new OpportunityLineItemSchedule(OpportunityLineItemId = l.Id,
                                                                           Quantity = 0,
                                                                           Type = 'Quantity',
                                                                           ScheduleDate = year);
            linesToInsert.add(s);
        }
        insert linesToInsert;
        
        
    }    

    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        system.debug(job);
    }    

}