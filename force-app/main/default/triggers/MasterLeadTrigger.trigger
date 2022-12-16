trigger MasterLeadTrigger on Lead(
  before insert, after insert, 
  before update, after update, 
  before delete, after delete) {

  if (Trigger.isBefore) {
    if (Trigger.isInsert) {
        LeadTriggerClass lt = new LeadTriggerClass(trigger.OldMap,trigger.newMap);
      getRegionInfo.getRegionLead(trigger.new);
        //LeadTriggerClass.AddFinchClub(trigger.new);
        LeadTriggerClass.accountCompare(trigger.new);
        LeadTriggerClass.govSpendOptOutOfEmail(trigger.new);
    } 
    if (Trigger.isUpdate) {
        if(TriggerContextUtility.isFirstRun()){
            system.debug('lead update trigger new, old, then map');
            system.debug(trigger.new[0].Country);
            system.debug(trigger.new[0].CountryCode);
             system.debug(trigger.new[0].finchClubLegacyId__c);
            system.debug('lead update reg');
            getRegionInfo.getRegionLead(trigger.new);
            LeadTriggerClass.accountCompare(trigger.new);    
            
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
            LeadTriggerClass.CsCallLead(trigger.new);
            TriggerContextUtility.setFirstRunFalse();
            
            
        }
    }
    if (Trigger.isDelete) {
      // Call class logic here!
    }
  }
}