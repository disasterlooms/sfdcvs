@isTest
public class TestResubNote {
    @testSetup
    private static void BuildTestData(){
        //BuildTestData.AddRecords();
    }
    Static testmethod void OppResubNoteChange() {
         /*  
               
        Opportunity opp = [Select Id,Spa_Resubmission_Note__c,(Select Id, Resubmission_Notes__c from Quotes) from Opportunity where id in (Select OpportunityId from Quote) limit 1];
        
        test.startTest();
        TriggerContextUtility.setFirstRunTrue();
        opp.Spa_Resubmission_Note__c = ' resub ';
        update opp;
        
        TriggerContextUtility.setFirstRunTrue();
        opp.Spa_Resubmission_Note__c = ' resub note 3 ';
        update opp;
        
        test.stopTest();
        
        Quote q = [Select id,Resubmission_Notes__c from quote where id = : opp.Quotes[0].Id];
        
        system.debug(q.Resubmission_Notes__c + ' quote resub notes');
        
        system.assert(q.Resubmission_Notes__c  != ' resub ');
        */
        
    }
    
}