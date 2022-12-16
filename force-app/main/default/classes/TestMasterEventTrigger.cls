@isTest
private class TestMasterEventTrigger{
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void MasterTaskTrigger() {
        // set up some test data to work with
        
        Test.Starttest();
       
        Event e = new Event(StartDateTime=system.today(),
        					EndDateTime=system.today()+5,
                            subject = 'site meeting'
                            );
        insert e;
        system.debug('get event id'+e.id);
        TriggerContextUtility.setFirstRunTrue();
        
        e.IsPrivate = true;
        update e;
        
         Event e2 = new Event(StartDateTime=system.today(),
        					EndDateTime=system.today()+5,
                            subject = 'test private',
                              isPrivate = true
                            );
        insert e2;       
       
        
        Test.stopTest();
        List<Event> echeck = [Select id,IsArchived,isPrivate from Event where id = :e.Id and isArchived = true];
        List<Event> echeck2 = [Select id,IsArchived,IsPrivate from Event where id = :e.Id ];
         
        system.debug(echeck);
        system.debug('query updated list'+echeck+echeck.size());
        system.debug(echeck2);
    }
    
}