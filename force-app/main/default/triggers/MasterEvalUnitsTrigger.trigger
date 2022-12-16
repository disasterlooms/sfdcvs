trigger MasterEvalUnitsTrigger on Eval_Unit_Details__c (
  before insert, after insert, 
  before update, after update, 
  before delete, after delete) {

  if (Trigger.isBefore) {
    if (Trigger.isInsert) {
      // Call class logic here!
      // 
      EvalUnitsMasterClass units  = new EvalUnitsMasterClass(Trigger.oldMap, Trigger.newMap);
      EvalUnitsMasterClass.productSearch(trigger.new);
      
      
    } 
    if (Trigger.isUpdate) {
      if(TriggerContextUtility.isFirstRun()){
      	 TriggerContextUtility.setFirstRunFalse();
         
         EvalUnitsMasterClass units  = new EvalUnitsMasterClass(Trigger.oldMap, Trigger.newMap);
         EvalUnitsMasterClass.updateunits(trigger.new);
         units.invoiced();
         units.closed();
    }
    }
    if (Trigger.isDelete) {
      // Call class logic here!
    }
  }

  if (Trigger.IsAfter) {
    if (Trigger.isInsert) {
      TriggerContextUtility.setFirstRunFalse();

       

    } 
    if (Trigger.isUpdate) {
      
      if(TriggerContextUtility.isFirstRun()){
        TriggerContextUtility.setFirstRunFalse();
      

      
    }
    }
    if (Trigger.isDelete) {
      // Call class logic here!
    }
  }
}