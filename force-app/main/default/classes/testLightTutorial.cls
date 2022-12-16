@isTest
public class testLightTutorial {
    static testmethod void testTutorial(){
        
        String whereclause = '';
        lightningtutorial__c tut = new lightningtutorial__c(SetupOwnerId = userinfo.getUserId(),Counter__c = 1);
        insert tut;        
        
        
        lightningtutorial__c settings = Tutorial.getUser();
        Tutorial.updateSettings(settings);
        Tutorial.updateTask(settings);
        
        delete tut;
        
        Task t = new Task(Subject='test ',ReminderDateTime = datetime.now()-1);
        insert t;
        
        lightningtutorial__c newtut = Tutorial.getUser();
        List<Task> tasks = Tutorial.activities(whereclause);
        Tutorial.TasktoUpdate(t.Id, true);
        Tutorial.deleteTask(t.Id);
        
        
               
    }
}