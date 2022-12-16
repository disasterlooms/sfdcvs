@isTest
private class testSchdeduleMulti {
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
        
        String lineid = opp.Id;
        
        
        ProductSchduleComponents.getmonths();
        List <OpportunityLineItemSchedule> schd = ProductSchduleComponents.getSchedule(lineid);
        ProductSchduleComponents.updateSched(schd);
     
            
        Test.stopTest();
        
    }
    
}