public with sharing class vfEvalUnitDetails {
    public String squery {get;set;}
    public Id eId {get;set;}    
    public List<Eval_Unit_Details__c> getrecords(){
        List<Eval_Unit_Details__c> records = Database.query(squery+'eId');
        
        system.debug(squery+' '+eId);
        system.debug('squery above');

        return records;
    }
}