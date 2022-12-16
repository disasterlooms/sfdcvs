trigger MasterOppPartnerTrigger on Opportunity_Partner__c (
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                TriggerContextUtility.setFirstRunFalse();
                OppPartnersMasterClass.partnerCreatedBRCheck(trigger.new);
                
                OppPartnersMasterClass oppres = 
                    new OppPartnersMasterClass(Trigger.oldMap, Trigger.newMap);
                
                
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
        
        if (Trigger.IsAfter) {
            if (Trigger.isInsert) {
                TriggerContextUtility.setFirstRunFalse();
                //OppPartnersMasterClass oppres = 
                   // new OppPartnersMasterClass(Trigger.oldMap, Trigger.newMap);
                //oppres.partnerChange();
                
                
            } 
            if (Trigger.isUpdate) {
                TriggerContextUtility.setFirstRunFalse();
                
                //OppPartnersMasterClass oppres = 
                    //new OppPartnersMasterClass(Trigger.oldMap, Trigger.newMap);
                //oppres.partnerChange();
                
            }
            if (Trigger.isDelete) {
                TriggerContextUtility.setFirstRunFalse();
                OppPartnersMasterClass oppres = 
                    new OppPartnersMasterClass(Trigger.oldMap, Trigger.newMap);
                oppres.partnerChange();
            }
        }
    }