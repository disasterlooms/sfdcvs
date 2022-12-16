trigger MasterTaskTrigger  on Task(
  before insert, after insert, 
  before update, after update, 
  before delete, after delete) {

  if (Trigger.isBefore) {
    if (Trigger.isInsert) {
       TriggerContextUtility.setFirstRunFalse();  
       TaskUpdate.spaSent(trigger.New);
    } 
    if (Trigger.isUpdate) {
        if(TriggerContextUtility.isFirstRun() ){
        }
    }
    if (Trigger.isDelete) {
      // Call class logic here!
    }
  }

  if (Trigger.IsAfter) {
    if (Trigger.isInsert) {
      TriggerContextUtility.setFirstRunFalse();  
      TaskUpdate.findTask(trigger.new);
      TaskUpdate.campaign(trigger.new);
      TaskUpdate.oppowner(trigger.new);  
     

      
      
    } 
    if (Trigger.isUpdate) {
        if(TriggerContextUtility.isFirstRun() ){
        TriggerContextUtility.setFirstRunFalse();
        TaskUpdate t = new TaskUpdate(Trigger.oldMap, Trigger.newMap);
        t.reminder();
        }
     
    }
    if (Trigger.isDelete) {
      // Call class logic here!
    }
  }
}