trigger AccountTrigger on Account(
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        //the global trigger allows classes to turn of opportunity and account triggers
        //this allows to skip triggers and classes when batch or product classes are running. 
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {                   
                getRegionInfo.getRegionAccount(trigger.new);
                AccountStateOwners insertbefore = 
                    new AccountStateOwners(Trigger.oldMap, Trigger.newMap);
                //latin america get state value and owner based on country is no longer needed
                //insertbefore.lacountrytostate(trigger.new);
                //
                //Originally, the next method updated states, now it maps the US counites
                //, adds domain info from the website, makes city proper style
                insertbefore.checkstatesowners(trigger.new);
                insertbefore.acctOwnerAssign(trigger.new);
                TriggerContextUtility.settriggerQueableFalse();
                //running AccountTeams class for test coverage until we can do a destructive change
                //
                AccountTeams atTest = 
                    new AccountTeams(Trigger.oldMap, Trigger.newMap);
                atTest.teams(trigger.new);
                
                
            } 
            if (Trigger.isUpdate) {
                if(TriggerContextUtility.isFirstRun()){
                    getRegionInfo.getRegionAccount(trigger.new);
                    system.debug('tirgger size '+trigger.new.size());
                    AccountStateOwners checker = 
                        new AccountStateOwners(Trigger.oldMap, Trigger.newMap);
                    checker.checkstatesowners(trigger.new);
                    checker.getPortalURL(trigger.new);
                    if(!system.isQueueable() && !system.isFuture() && trigger.new.size()< 200){                        
                        checker.updateOwner();
                        TriggerContextUtility.settriggerQueableFalse();
                    }
                }
            }
            if (Trigger.isDelete) {
                // Call class logic here!
                AccountStateOwners checker = 
                    new AccountStateOwners(Trigger.oldMap, Trigger.newMap);
                checker.acctDelete();
            }
        }
        
        if (Trigger.IsAfter) {
            if (Trigger.isInsert) {
                TriggerContextUtility.setFirstRunFalse();
                AccountStateOwners insertbefore = 
                    new AccountStateOwners(Trigger.oldMap, Trigger.newMap);
                AccountStateOwners.acctUrlFuture(trigger.new);
                if(!system.isQueueable() && !system.isFuture()){
                    TriggerContextUtility.settriggerQueableFalse();
                    insertbefore.updateOwner();
                }
            } 
            if (Trigger.isUpdate) {
                TriggerContextUtility.settriggerQueableFalse();
                if(TriggerContextUtility.isFirstRun()){
                    TriggerContextUtility.setFirstRunFalse();
                    
                }
            }
            if (Trigger.isDelete) {                    
                TriggerContextUtility.setFirstRunFalse();
                // Call class logic here!
            }
        }
    }