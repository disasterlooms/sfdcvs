//Before Changes
trigger MasterOpportunity on Opportunity(
    before insert,
    after insert,
    before update,
    after update,
    before delete,
    after delete
) {
    //the global trigger allows classes to turn of opportunity and account triggers
    //this allows to skip triggers and classes when batch or product classes are
    if (TriggerContextUtility.isglobalTriggers()) {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                //stop the update triggers from running on inserts that will cause updates
                
                //make sure the trigger is not from a cloned record
                Boolean cloning = OpportunityRecCheck.removeOpps(Trigger.new);
                if (cloning == true) {
                    system.debug('before insert trigger clone stop');
                    OpportunityCreate.pricebook(Trigger.new);
                }
                
                OpportunityCreate.pricebook(Trigger.new);
                OpportunityCreate.updateopp(Trigger.new);
            }
            if (Trigger.isUpdate) {
                if (TriggerContextUtility.isFirstRun()) {                   
                    
                    OppsSpaUpdates checker = new OppsSpaUpdates(
                        Trigger.oldMap,
                        Trigger.newMap
                    );
                    checker.SpaSubmission();
                    
                    //make sure the trigger is not from a cloned record
                    Boolean cloning = OpportunityRecCheck.oppTrigUpdate(
                        Trigger.oldMap,
                        Trigger.NewMap
                    );
                    if (cloning == true) {
                        system.debug('update trigger clone stop');
                        return;
                    }
                    system.debug('not cloning update trigger');
                    
                    //since the community partners do not have access to update quotes yet,
                    //this allows them to resubmit on the opportunity page. This will
                    //be deprecated soon as to reduce the amount of update triggers being ran.
                    
                    //commenting out below because Spas have been moved from opportunities
                    //to Quote object. there is no way to use the opportunity fields to trigger events. It
                    //only delays the system and it is not necessary. not deleting code in case
                    //some code is useful
                    
                    //new OppsSpaUpdates(Trigger.oldMap, Trigger.newMap);
                    //checker.SpaStageApproval();
                    
                    //new OppsSpaUpdates(Trigger.oldMap, Trigger.newMap);
                    //OppsSpaUpdates.AddTeam(trigger.new,Trigger.oldMap, Trigger.newMap);
                    
                    //TriggerContextUtility.setFirstRunFalse();
                    //By Jay
                    //
                    //jason orbision 9.14.2021
                    //removing on update..once price book is set, need to clone opportunity
                    //if there is a change in price book needed. a clone will at least allow the
                    //user to keep all their products that are active in other price book as opposed
                    //to a price book change which deletes them all.. and a price book change can only 
                    //occur programatically if they need to delete all the products and then change the price book
                    
                    //OpportunityCreate.pricebook(Trigger.new);
                }
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
        
        if (Trigger.IsAfter) {
            if (Trigger.isInsert ) {                   
                    //stop the update triggers from running on inserts that will cause updates
                    TriggerContextUtility.setFirstRunFalse();
                    OpportunityCreate.resellerbidreg(Trigger.new);
                    
                    Boolean cloning = OpportunityRecCheck.removeOpps(Trigger.new);
                    if (cloning == true) {
                        system.debug('after insert trigger clone stop');
                        OppCloneProducts.ChangePBE(Trigger.new);
                    } else {
                        OpportunityCreate.createchildrecords(Trigger.new);
                    }
            }
            if (Trigger.isUpdate) {
                if (TriggerContextUtility.isFirstRun()) {
                    TriggerContextUtility.setFirstRunFalse();
                }
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
    }
}