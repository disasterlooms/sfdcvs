trigger MasterEventTrigger on Event(
  before insert, after insert, 
  before update, after update, 
  before delete, after delete) {

  if (Trigger.isBefore) {
    if (Trigger.isInsert) {
       TriggerContextUtility.setFirstRunFalse();  
       MasterEventClass.typeSearch(trigger.new);
    } 
    if (Trigger.isUpdate) {
        if(TriggerContextUtility.isFirstRun() ){
          MasterEventClass.typeSearch(trigger.new);
        }
    }
    if (Trigger.isDelete) {
      // Call class logic here!
    }
  }

  if (Trigger.IsAfter) {
    if (Trigger.isInsert) {
      TriggerContextUtility.setFirstRunFalse();     
      MasterEventClass.privateevent(trigger.new);
      MasterEventClass t = new MasterEventClass(Trigger.oldMap, Trigger.newMap);
      
      
    } 
    if (Trigger.isUpdate) {
        if(TriggerContextUtility.isFirstRun() ){
          MasterEventClass.privateevent(trigger.new);  
        }
     
    }
    if (Trigger.isDelete) {
      // Call class logic here!
    }
  }
}