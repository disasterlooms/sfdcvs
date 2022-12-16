@isTest
private class TestMasterTaskTrigger{
	@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void MasterTaskTrigger() {
        // set up some test data to work with
        
        Test.Starttest();
        Lead l = new Lead (LastName ='XX', Company='apex testing company');
        insert l;

        
        Campaign c = new Campaign(Name='Test apex campaign');
        insert c;
        
        CampaignMember c1 = new CampaignMember(CampaignId= c.Id, LeadId = l.Id);
        insert c1;

        Task t = new Task(Subject= 'test apex', Whoid = l.Id, Status='New', Priority='Normal', Type = 'Email');
        insert t;

        Opportunity opp = [Select Id from Opportunity limit 1];
        
        Task tlead = new Task(Subject= 'test apex', Whoid = l.Id, Status='New', Priority='Normal', Type = 'Email');
        insert tlead;
        
        Task topp = new Task(Subject= 'test apex', Status='New', Priority='Normal', Type = 'Email', 
                          whatId = opp.id,isReminderSet = true, ReminderDateTime = datetime.now());
        insert topp;
        
        Quote q = new Quote(OpportunityId = opp.id,name ='Apex Test');
        insert q;
        
        Task tquote = new  Task(Subject= 'test apex', Status='New', Priority='Normal', Type = 'Email', 
                          whatId = q.id);
        insert tquote;
        
        TriggerContextUtility.setFirstRunTrue();
        topp.IsReminderSet = false;
        update topp;
        Task toppassert = [Select id,ReminderDateTime from task where id = : topp.Id limit 1 ];
        
		
       
        
Test.stopTest();
}
}