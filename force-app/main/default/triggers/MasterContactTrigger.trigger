trigger MasterContactTrigger on Contact(
    before insert, after insert, 
    before update, after update, 
    before delete, after delete,
    after undelete) {
        
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                // Call class logic here!
                getRegionInfo.getRegionContact(trigger.new);
                ContactUpdate.UpdateOwner(trigger.new);
            } 
            if (Trigger.isUpdate) {                             
                if(TriggerContextUtility.isFirstRun()){ 
                     getRegionInfo.getRegionContact(trigger.new);
                    ContactUpdate.UpdateOwner(trigger.new);
                    ContactUpdate portal = 
                        new ContactUpdate(Trigger.oldMap, Trigger.newMap);
                    portal.UpdatePortalInfo();
                }
            }
            if (Trigger.isDelete) {
                ContactUpdate cupdate = 
                    new ContactUpdate(Trigger.oldMap, Trigger.newMap);
                //cupdate.finches();
                // Call class logic here!
            }
        }
        
        if (Trigger.IsAfter) {
            if (Trigger.isInsert) {
                TriggerContextUtility.setFirstRunFalse();
                ContactUpdate cupdate = 
                    new ContactUpdate(Trigger.oldMap, Trigger.newMap);
                //cupdate.finches();
            } 
            if (Trigger.isUpdate) {
                //ContactUpdate.UpdatePortalInfo(trigger.new);
                //cupdate.finches();
                if(TriggerContextUtility.isFirstRun()){
                    TriggerContextUtility.setFirstRunFalse();
                    ContactUpdate cupdate = 
                        new ContactUpdate(Trigger.oldMap, Trigger.newMap);
                }
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
            if (Trigger.isunDelete) {
                ContactUpdate cupdate = 
                    new ContactUpdate(Trigger.oldMap, Trigger.newMap);
                //cupdate.finches();
                // Call class logic here!
            }
        }
    }