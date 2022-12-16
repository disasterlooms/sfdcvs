@isTest
private class testSearchActiivtySosl {
@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }       
    static testmethod void Testgetrecords()
  {		        
      
      String recid  = '';
     
      test.startTest();
      
      Account a = [Select id from account limit 1];
      Task t = new Task(subject='test this event',
                       WhatId= a.Id,
                       description='test',
                       ActivityDate = date.today());
      
      insert t;
      
      Event e = new Event(subject='test this event',
                       WhatId= a.Id,
                       description='test',
                       ActivityDate = date.today(),
                       DurationInMinutes = 2,
                         ActivityDateTime = datetime.now()); 
      
      insert e;
      
      
      
      recid = a.Id;
      List<List<SObject>> testResults = searchOjbectsSosl.getRecId(recid);
      system.debug('here is test results');
      system.debug(testResults);
      test.stopTest();
    }

}