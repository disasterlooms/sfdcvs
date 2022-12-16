@isTest
private class TestScheduleNewMonth {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void newmonth() {  
        
        Test.startTest();
        
        opportunitylineitem opp = [select id,product2Id,product2.CanUseQuantitySchedule  from opportunitylineitem limit 1];
        
        product2 p = [Select id,CanUseQuantitySchedule from product2 where id =: opp.product2Id limit 1 ];
        
        p.CanUseQuantitySchedule = true;
        update p;
        
        OpportunityLineItemSchedule s = new OpportunityLineItemSchedule(type ='quantity',
                                                                       opportunitylineitemid = opp.id,
                                                                       ScheduleDate = date.today(),
                                                                       Quantity = 10);
        insert s;
        
        OppScheduleNewMonth uca = new OppScheduleNewMonth();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        
    }
    
}