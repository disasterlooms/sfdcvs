@IsTest
public class TestMasterEvalUnitsTrigger  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    Static testmethod void MasterEvalUnitsTrigger(){
        Test.startTest();
        TriggerContextUtility.setFirstRunTrue();
        
        Eval_Unit_Details__c u = [Select Id,Status__c, Status_Date_Change__c,Write_Off_Date__c
                                 from Eval_Unit_Details__c limit 1];
        u.Status_Date_Change__c = null;
        u.Write_Off_Date__c = null;
        update u;
        TriggerContextUtility.setFirstRunTrue();
        
        u.Status__c = 'Write-off';
        update u;
        
        Test.stopTest();
    } 
}